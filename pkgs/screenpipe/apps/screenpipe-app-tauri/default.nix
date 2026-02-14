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
, v8Lib
, ...
}:
let
  appLock = builtins.readFile "${src}/apps/screenpipe-app-tauri/src-tauri/Cargo.lock";
  filteredAppLock = lib.replaceStrings
    [
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
      ''
        [[package]]
        name = "hf-hub"
        version = "0.3.2"
        source = "registry+https://github.com/rust-lang/crates.io-index"
        checksum = "2b780635574b3d92f036890d8373433d6f9fc7abb320ee42a5c25897fc8ed732"
        dependencies = [
         "dirs 5.0.1",
         "indicatif",
         "log",
         "native-tls",
         "rand 0.8.5",
         "serde",
         "serde_json",
         "thiserror 1.0.69",
         "ureq 2.12.1",
        ]

      ''
      ''
         "nokhwa-bindings-macos",
      ''
    ]
    [ "" "" "" "" ]
    appLock;
in
rustPlatform.buildRustPackage rec {
  pname = "screenpipe-app";
  version = "2.0.439";

  inherit src;
  cargoRoot = "apps/screenpipe-app-tauri/src-tauri";
  buildAndTestSubdir = cargoRoot;

  cargoLock = {
    lockFileContents = filteredAppLock;
    allowBuiltinFetchGit = true;
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
  RUSTY_V8_ARCHIVE = "${v8Lib}/lib/librusty_v8.a";
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
