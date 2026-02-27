{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  makeWrapper,
  pipewire,
  ffmpeg,
  libnotify,
  ollama,
  bc,
  procps,
  gnused,
  gnugrep,
  gawk,
  wl-clipboard,
  xclip,
  cudaPackages,
  zlib,
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    faster-whisper
  ]);

  cudaPath = lib.makeLibraryPath [
    cudaPackages.cudnn
    cudaPackages.libcublas
    cudaPackages.cuda_cudart
    zlib
  ];
in
stdenv.mkDerivation rec {
  pname = "xhisper-local";
  version = "2025-02-25";

  src = fetchFromGitHub {
    owner = "wpbryant";
    repo = "xhisper-local";
    rev = "9a53cbad3adfdf55a2bf44d469a8e3475c3bdeb6";
    hash = "sha256-keYX3+kKaKHyaNMzuXRKuSlayE66m85sSoAm/SmQmTk=";
  };

  postPatch = ''
    sed -i '/export LD_LIBRARY_PATH=/d' xhisper.sh
    sed -i 's/XHISPERTOOL="xhispertool"/XHISPERTOOL="''${XHISPERTOOL:-xhispertool}"/' xhisper.sh
    sed -i 's/XHISPERTOOLD="xhispertoold"/XHISPERTOOLD="''${XHISPERTOOLD:-xhispertoold}"/' xhisper.sh
    sed -i 's/TRANSCRIPT_SCRIPT="xhisper_transcribe"/TRANSCRIPT_SCRIPT="''${TRANSCRIPT_SCRIPT:-xhisper_transcribe}"/' xhisper.sh
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    $CC -O2 -Wall -Wextra xhispertool.c -o xhispertool
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 xhispertool $out/bin/xhispertool
    ln -s xhispertool $out/bin/xhispertoold
    install -Dm755 xhisper.sh $out/bin/xhisper
    install -Dm755 xhisper_transcribe.py $out/bin/xhisper_transcribe
    install -Dm644 default_xhisperrc $out/share/xhisper/default_xhisperrc
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/xhisper \
      --prefix PATH : ${lib.makeBinPath [
        pipewire
        ffmpeg
        libnotify
        ollama
        bc
        procps
        gnused
        gnugrep
        gawk
        wl-clipboard
        xclip
        pythonEnv
      ]} \
      --prefix LD_LIBRARY_PATH : ${cudaPath} \
      --set XHISPERTOOL $out/bin/xhispertool \
      --set XHISPERTOOLD $out/bin/xhispertoold \
      --set TRANSCRIPT_SCRIPT $out/bin/xhisper_transcribe
  '';

  meta = with lib; {
    description = "Dictate anywhere in Linux + AI";
    homepage = "https://github.com/wpbryant/xhisper-local";
    license = licenses.mit;
    mainProgram = "xhisper";
    platforms = platforms.linux;
  };
}
