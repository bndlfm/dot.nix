{ lib
, stdenv
, rustPlatform
, bun
, cmake
, pkg-config
, makeWrapper
, glib
, gtk3
, libsoup_3
, webkitgtk_4_1
, libayatana-appindicator
, openssl
, xdotool
, libgbm
, mesa
, pipewire
, libxi
, libxcb
, libxtst
, libpulseaudio
, alsa-lib
, oniguruma
, llvmPackages
, src
, ortLib
, ...
}:
let
  appLock = builtins.readFile "${src}/apps/screenpipe-app-tauri/src-tauri/Cargo.lock";
  filteredAppLock = lib.replaceStrings
    [
      # Remove problematic macos-only git dependencies that collide or fail
      ''
        [[package]]
        name = "nokhwa-bindings-macos"
        version = "0.2.0"
        source = "git+https://github.com/CapSoftware/nokhwa?rev=0d3d1f30a78b#0d3d1f30a78bb4616b4a4d0939a29ad0c1a8e14f"
        dependencies = [
         "block",
         "cocoa-foundation 0.1.2",
         "core-media-sys",
         "core-video-sys",
         "flume 0.10.14",
         "nokhwa-core",
         "objc",
         "once_cell",
        ]

      ''
      ''
        [[package]]
        name = "nokhwa-core"
        version = "0.1.0"
        source = "git+https://github.com/CapSoftware/nokhwa?rev=0d3d1f30a78b#0d3d1f30a78bb4616b4a4d0939a29ad0c1a8e14f"
        dependencies = [
         "bytes",
         "image 0.24.9",
         "thiserror 1.0.69",
        ]

      ''
      # Replace hf-hub registry with git to match workspace
      ''
        [[package]]
        name = "hf-hub"
        version = "0.3.2"
        source = "registry+https://github.com/rust-lang/crates.io-index"
        checksum = "2b780635574b3d92f036890d8373433d6f9fc7abb320ee42a5c25897fc8ed732"
      ''
      ''
         "nokhwa-bindings-macos",
      ''
    ]
    [
      ""
      ""
      ''
        [[package]]
        name = "hf-hub"
        version = "0.3.2"
        source = "git+https://github.com/neo773/hf-hub#437dcf4049233f4a0e0cfc4e1c1dbf5ed2c57760"
      ''
      ""
    ]
    appLock;

  hfHubEntry = ''

[[package]]
name = "num_cpus"
version = "1.17.0"
source = "registry+https://github.com/rust-lang/crates.io-index"
checksum = "91df4bbde75afed763b708b7eee1e8e7651e02d97f6d5dd763e89367e957b23b"
dependencies = [
 "hermit-abi",
]
'';
in
rustPlatform.buildRustPackage rec {
  pname = "screenpipe-app";
  version = "2.0.482";

  inherit src;
  cargoRoot = "apps/screenpipe-app-tauri/src-tauri";
  buildAndTestSubdir = cargoRoot;

  cargoLock = {
    lockFileContents = filteredAppLock + hfHubEntry;
    allowBuiltinFetchGit = true;
    outputHashes = {
      "accessibility-0.3.0" = "sha256-SBYB62kFmldfangDBtnLqA+T9iUfn+GCCvi0p6E5ou8=";
      "accessibility-sys-0.2.0" = "sha256-S/o9u4T7jA7Y+7KPr6vW6mKjD2Z9fX9oM0N0X9oM0N0=";
      "cidre-0.14.0" = "sha256-eBDf4wMZrN2CwEHKMJiolK1I5s5SSoe1X2XRQ4OE7o8=";
      "cpal-0.15.3" = "sha256-XNRx1VgDQ2UrPETX0vZY7l/3RiBXPhFAdJ8udyWUDoI=";
      "ffmpeg-sidecar-2.3.0" = "sha256-iRl3raOR5rDvpx4vZ7dBGfXqxWbyi+hcFbMC2i10JqU=";
      "fix-path-env-0.0.0" = "sha256-UygkxJZoiJlsgp8PLf1zaSVsJZx1GGdQyTXqaFv3oGk=";
      "hf-hub-0.3.2" = "sha256-hTAdRgJKCN4kTyZXy4SOHPEhBY4/UX+tWJPoUroKLD0=";
      "knf-rs-0.2.4" = "sha256-06k6o14+RlY+04p0BKi++JCHRh+0/jg/wg/wdgPm2Yw=";
      "knf-rs-sys-0.2.4" = "sha256-06k6o14+RlY+04p0BKi++JCHRh+0/jg/wg/wdgPm2Yw=";
      "rusty-tesseract-1.1.10" = "sha256-XT74zGn+DetEBUujHm4Soe2iorQcIoUeZbscTv+64hw=";
      "sck-rs-0.1.0" = "sha256-unTVi0HtUY4KPU8S9gPaZAs7v4Z8UMbz+T0EGVsm19o=";
      "tauri-nspanel-2.0.1" = "sha256-pQgv/Lkc9yE+DSv+MdOV1NZRj2nkMhAm+Wn41qvdvvE=";
      "vad-rs-0.2.0" = "sha256-F6jf1fhheeyGmmClUg3fzT1klhXRgfE0szjfG9J+Nl4=";
      "whisper-rs-0.15.1" = "sha256-ehMAYbRY3MI6b6ehRBbhYvdcbRxVrSoWJOkmaP/zM7c=";
      "whisper-rs-sys-0.14.1" = "sha256-ehMAYbRY3MI6b6ehRBbhYvdcbRxVrSoWJOkmaP/zM7c=";
      "windows-icons-0.1.1" = "sha256-Lrw9W71ihFYsC4EHThfQdmeJdEW3dE71NiNrFKZp7Ks=";
    };
  };

  postPatch = ''
    cp /build/cargo-vendor-dir/Cargo.lock apps/screenpipe-app-tauri/src-tauri/Cargo.lock
    sed -i '/^\[target.\x27cfg(target_os = "macos")\x27.dependencies\]/,/^\[target.\x27cfg(target_os = "windows")\x27.dependencies\]/{/^\[target.\x27cfg(target_os = "windows")\x27.dependencies\]/!d;}' apps/screenpipe-app-tauri/src-tauri/Cargo.toml
    # Linux package: skip deep-link auto registration in setup hook.
    # In Nix runtime environments this can fail with ENOENT before app init.
    sed -i 's/#\[cfg(any(windows, target_os = "linux"))\]/#[cfg(windows)]/' apps/screenpipe-app-tauri/src-tauri/src/main.rs
    cp ${bun}/bin/bun apps/screenpipe-app-tauri/src-tauri/bun-x86_64-unknown-linux-gnu
    chmod +x apps/screenpipe-app-tauri/src-tauri/bun-x86_64-unknown-linux-gnu
  '';

  cargoBuildFlags = [
    "--package"
    "screenpipe-app"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    glib
    gtk3
    libsoup_3
    webkitgtk_4_1
    libayatana-appindicator
    openssl
    xdotool
    libgbm
    mesa
    pipewire
    libxi
    libxcb
    libxtst
    libpulseaudio
    oniguruma
    llvmPackages.clang
    llvmPackages.libclang
  ];

  preBuild = ''
    mkdir -p apps/screenpipe-app-tauri/out
    cat > apps/screenpipe-app-tauri/out/index.html <<'EOF'
    <!doctype html>
    <html><head><meta charset="utf-8"><title>screenpipe</title></head>
    <body><div id="root"></div></body></html>
    EOF
  '';

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  ORT_LIB_LOCATION = "${ortLib}/lib";
  ORT_STRATEGY = "system";
  RUSTONIG_SYSTEM_LIBONIG = "1";
  NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  doCheck = false;

  postFixup = ''
    wrapProgram "$out/bin/screenpipe-app" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        alsa-lib
        glib
        gtk3
        libsoup_3
        webkitgtk_4_1
        libayatana-appindicator
        openssl
        xdotool
        libgbm
        mesa
        pipewire
        libxi
        libxcb
        libxtst
        libpulseaudio
        oniguruma
        ortLib
      ]}:/run/opengl-driver/lib
  '';

  meta = with lib; {
    description = "screenpipe desktop application";
    homepage = "https://github.com/mediar-ai/screenpipe";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
