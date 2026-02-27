{ lib
, stdenv
, rustPlatform
, pkg-config
, cmake
, makeWrapper
, autoPatchelfHook
, addDriverRunpath
, callPackage
, symlinkJoin
, alsa-lib
, atk
, cairo
, dbus
, gdk-pixbuf
, glib
, gtk3
, libsoup_3
, llvmPackages
, libgbm
, mesa
, oniguruma
, openssl
, pango
, webkitgtk_4_1
, pipewire
, xdotool
, libxi
, libxcb
, libxtst
, libpulseaudio
, ffmpeg
, sqlite
, tesseract
, cudatoolkit ? null
, src
, cudaLibs
, ortLib
}:
let
  rootLock = builtins.readFile "${src}/Cargo.lock";
  filteredRootLock = lib.replaceStrings
    [
      ''

[[patch.unused]]
name = "half"
version = "2.5.0"
source = "git+https://github.com/starkat99/half-rs.git?tag=v2.5.0#989d2700376b311a4765f43eaec8e9661bfa579a"
''
    ]
    [ "" ]
    rootLock;

  backend = rustPlatform.buildRustPackage (rec {
  pname = "screenpipe-backend";
  version = "0.3.151";

  inherit src;

  postPatch = ''
    # Remove unused half patch to match filteredRootLock and prevent Cargo from trying to update it
    sed -i '/half = { git = "https:\/\/github.com\/starkat99\/half-rs.git"/d' Cargo.toml
    sed -i '$d' Cargo.lock
    sed -i '$d' Cargo.lock
    sed -i '$d' Cargo.lock
    sed -i '$d' Cargo.lock
    sed -i '$d' Cargo.lock
  '';

  cargoLock = {
    lockFileContents = filteredRootLock;
    allowBuiltinFetchGit = true;
    outputHashes = {
      "accessibility-0.3.0" = "sha256-SBYB62kFmldfangDBtnLqA+T9iUfn+GCCvi0p6E5ou8=";
      "accessibility-sys-0.2.0" = "sha256-S/o9u4T7jA7Y+7KPr6vW6mKjD2Z9fX9oM0N0X9oM0N0=";
      "cidre-0.14.1" = "sha256-YnMkHTyuAjszhu62zv7QQZCs38nJg9UzkoGocPZHX08=";
      "cpal-0.15.3" = "sha256-XNRx1VgDQ2UrPETX0vZY7l/3RiBXPhFAdJ8udyWUDoI=";
      "ffmpeg-sidecar-2.3.0" = "sha256-iRl3raOR5rDvpx4vZ7dBGfXqxWbyi+hcFbMC2i10JqU=";
      "hf-hub-0.3.2" = "sha256-hTAdRgJKCN4kTyZXy4SOHPEhBY4/UX+tWJPoUroKLD0=";
      "knf-rs-0.2.4" = "sha256-06k6o14+RlY+04p0BKi++JCHRh+0/jg/wg/wdgPm2Yw=";
      "knf-rs-sys-0.2.4" = "sha256-06k6o14+RlY+04p0BKi++JCHRh+0/jg/wg/wdgPm2Yw=";
      "rusty-tesseract-1.1.10" = "sha256-XT74zGn+DetEBUujHm4Soe2iorQcIoUeZbscTv+64hw=";
      "sck-rs-0.1.0" = "sha256-unTVi0HtUY4KPU8S9gPaZAs7v4Z8UMbz+T0EGVsm19o=";
      "vad-rs-0.2.0" = "sha256-F6jf1fhheeyGmmClUg3fzT1klhXRgfE0szjfG9J+Nl4=";
      "whisper-rs-0.15.1" = "sha256-ehMAYbRY3MI6b6ehRBbhYvdcbRxVrSoWJOkmaP/zM7c=";
      "whisper-rs-sys-0.14.1" = "sha256-ehMAYbRY3MI6b6ehRBbhYvdcbRxVrSoWJOkmaP/zM7c=";
    };
  };

  cargoBuildFlags = [
    "-p"
    "screenpipe-server"
    "--bin"
    "screenpipe"
  ];

  buildFeatures = lib.optionals (stdenv.hostPlatform.isLinux && cudatoolkit != null) [ "cuda" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
    autoPatchelfHook
    addDriverRunpath
    makeWrapper
  ] ++ cudaLibs;

  buildInputs = [
    alsa-lib
    atk
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk3
    libsoup_3
    llvmPackages.clang
    llvmPackages.libclang
    libgbm
    mesa
    oniguruma
    openssl
    pango
    pipewire
    webkitgtk_4_1
    xdotool
    libxi
    libxcb
    libxtst
    libpulseaudio
  ] ++ cudaLibs;

  propagatedBuildInputs = [
    ffmpeg
    sqlite
    tesseract
  ] ++ cudaLibs;

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  ORT_LIB_LOCATION = "${ortLib}/lib";
  ORT_STRATEGY = "system";
  RUSTONIG_SYSTEM_LIBONIG = "1";
  NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  doCheck = false;

  postFixup = ''
    wrapProgram "$out/bin/screenpipe" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath (cudaLibs ++ [ ortLib ])}:/run/opengl-driver/lib
  '';

  meta = with lib; {
    description = "screenpipe backend and CLI";
    homepage = "https://github.com/mediar-ai/screenpipe";
    license = licenses.mit;
    platforms = platforms.linux;
  };
} // lib.optionalAttrs (cudatoolkit != null) {
  CUDA_PATH = "${cudatoolkit}";
  CUDA_ROOT = "${cudatoolkit}";
  CUDA_TOOLKIT_ROOT_DIR = "${cudatoolkit}";
});

  app = callPackage ./apps/screenpipe-app-tauri/default.nix {
    inherit src ortLib rustPlatform;
  };
in
symlinkJoin {
  name = "screenpipe";
  paths = [ backend app ];
  passthru = {
    screenpipe-backend = backend;
    screenpipe-cli = backend;
    screenpipe-app = app;
  };
}
