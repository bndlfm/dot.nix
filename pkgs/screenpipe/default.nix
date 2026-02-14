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
, v8Lib
}:
let
  backend = rustPlatform.buildRustPackage (rec {
  pname = "screenpipe-backend";
  version = "0.3.139";

  inherit src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
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
  RUSTY_V8_ARCHIVE = "${v8Lib}/lib/librusty_v8.a";
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
    inherit src ortLib v8Lib rustPlatform;
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
