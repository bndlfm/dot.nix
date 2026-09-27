{
  lib,
  stdenv,
  fetchFromGitHub,
  gnumake,
  pkg-config,
  openssl,
  usrsctp,
  libsrtp,
  ffmpeg,
  opus,
  libpulseaudio,
  libpcap,
  libX11,
  libXtst,
  pipewire,
  dbus,
  wayland,
}:
stdenv.mkDerivation rec {
  pname = "bsdrX";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "nextime";
    repo = "bsdrX";
    rev = "ffcb4f8efa3375185997561c6b2af7a7c8845e4b";
    hash = "sha256-5CQwy/Kyr0x4zAE2FW4qUf9/L/3bwzZQUitbklZ5EjE=";
  };

  nativeBuildInputs = [
    gnumake
    pkg-config
    wayland
  ];

  buildInputs = [
    openssl
    usrsctp
    libsrtp
    ffmpeg
    opus
    libpulseaudio
    libpcap
    libX11
    libXtst
    pipewire
    dbus
  ];

  configurePhase = ''
    runHook preConfigure
    ./configure --prefix="$out" --no-onnx-fetch
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    make -j"$NIX_BUILD_CORES"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install prefix="$out"
    runHook postInstall
  '';

  meta = {
    description = "Bigscreen Remote Desktop host for Linux";
    homepage = "https://github.com/nextime/bsdrX";
    license = lib.licenses.gpl3Plus;
    mainProgram = "bsdr_agent";
    platforms = lib.platforms.linux;
  };
}
