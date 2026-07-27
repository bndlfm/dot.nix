{
  lib,
  stdenv,
  rustPlatform,
  bun,
  cmake,
  pkg-config,
  makeWrapper,
  glib,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
  glib-networking,
  libayatana-appindicator,
  openssl,
  xdotool,
  libgbm,
  mesa,
  pipewire,
  libxi,
  libxcb,
  libxtst,
  libpulseaudio,
  alsa-lib,
  oniguruma,
  openblas,
  llvmPackages,
  tesseract,
  src,
  ortLib,
  ...
}:
let
  appLock = builtins.readFile "${src}/apps/screenpipe-app-tauri/src-tauri/Cargo.lock";
  filteredAppLock =
    lib.replaceStrings
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
        # Remove duplicate cidre-0.15.1 without ?rev= (different SHA, causes vendor dir symlink collision)
        ''
          [[package]]
          name = "cidre"
          version = "0.15.1"
          source = "git+https://github.com/yury/cidre.git#7049fbfbb92a5b3ed034d3c3162e2fccf3dd5f3e"
          dependencies = [
           "cc",
           "cidre-macros 0.5.0",
           "half",
           "parking_lot",
           "tokio",
          ]

        ''
        " \"nokhwa-bindings-macos\","
        # sck-rs dep reference to cidre without ?rev= — redirect to the explicit ?rev= entry
        " \"cidre 0.15.1 (git+https://github.com/yury/cidre.git)\","
        # screenpipe-audio in the app lock is stale: missing "sonora" dep added upstream
        " \"serde_json\",\n \"symphonia\","
      ]
      [
        ""
        ""
        ""
        ""
        " \"cidre 0.15.1 (git+https://github.com/yury/cidre.git?rev=8481f3f0dc7dd39bb5be80d9424bfac0cad3801a)\","
        " \"serde_json\",\n \"sonora\",\n \"symphonia\","
      ]
      appLock;

  # sonora packages are missing from the app-specific Cargo.lock (stale lock).
  # Add them verbatim from the root workspace Cargo.lock.
  sonoraEntries = ''

    [[package]]
    name = "sonora"
    version = "0.1.0"
    source = "git+https://github.com/dignifiedquire/sonora.git?rev=70c673606e1db8442a8ba20659b2bc7355555274#70c673606e1db8442a8ba20659b2bc7355555274"
    dependencies = [
     "sonora-aec3",
     "sonora-agc2",
     "sonora-common-audio",
     "sonora-ns",
     "sonora-simd",
     "tracing",
    ]

    [[package]]
    name = "sonora-aec3"
    version = "0.1.0"
    source = "git+https://github.com/dignifiedquire/sonora.git?rev=70c673606e1db8442a8ba20659b2bc7355555274#70c673606e1db8442a8ba20659b2bc7355555274"
    dependencies = [
     "sonora-common-audio",
     "sonora-fft",
     "sonora-simd",
    ]

    [[package]]
    name = "sonora-agc2"
    version = "0.1.0"
    source = "git+https://github.com/dignifiedquire/sonora.git?rev=70c673606e1db8442a8ba20659b2bc7355555274#70c673606e1db8442a8ba20659b2bc7355555274"
    dependencies = [
     "bytemuck",
     "derive_more",
     "sonora-common-audio",
     "sonora-fft",
     "sonora-simd",
     "tracing",
    ]

    [[package]]
    name = "sonora-common-audio"
    version = "0.1.0"
    source = "git+https://github.com/dignifiedquire/sonora.git?rev=70c673606e1db8442a8ba20659b2bc7355555274#70c673606e1db8442a8ba20659b2bc7355555274"
    dependencies = [
     "derive_more",
     "sonora-simd",
    ]

    [[package]]
    name = "sonora-fft"
    version = "0.1.0"
    source = "git+https://github.com/dignifiedquire/sonora.git?rev=70c673606e1db8442a8ba20659b2bc7355555274#70c673606e1db8442a8ba20659b2bc7355555274"

    [[package]]
    name = "sonora-ns"
    version = "0.1.0"
    source = "git+https://github.com/dignifiedquire/sonora.git?rev=70c673606e1db8442a8ba20659b2bc7355555274#70c673606e1db8442a8ba20659b2bc7355555274"
    dependencies = [
     "sonora-fft",
    ]

    [[package]]
    name = "sonora-simd"
    version = "0.1.0"
    source = "git+https://github.com/dignifiedquire/sonora.git?rev=70c673606e1db8442a8ba20659b2bc7355555274#70c673606e1db8442a8ba20659b2bc7355555274"
    dependencies = [
     "cpufeatures 0.3.0",
    ]
  '';
in
rustPlatform.buildRustPackage rec {
  pname = "screenpipe-app";
  version = "2.5.87";

  inherit src;
  cargoRoot = "apps/screenpipe-app-tauri/src-tauri";
  buildAndTestSubdir = cargoRoot;

  cargoLock = {
    lockFileContents = filteredAppLock + sonoraEntries;
    allowBuiltinFetchGit = true;
    outputHashes = {
      "accessibility-0.3.0" = "sha256-SBYB62kFmldfangDBtnLqA+T9iUfn+GCCvi0p6E5ou8=";
      "accessibility-sys-0.2.0" = "sha256-SBYB62kFmldfangDBtnLqA+T9iUfn+GCCvi0p6E5ou8=";
      # antirez-asr-sys, audiopipe, qwen3-asr-sys omitted: same git repo with C
      # submodules; allowBuiltinFetchGit fetches them with submodules=true.
      "cidre-0.15.1" = "sha256-xdWBuDF4j8sUDqTY0NFBZ5wfkfq47DyZxZi+ZGt8ODI=";
      "cpal-0.15.3" = "sha256-40NAK+MFZ8Yciho3HIwwGUgU3WDb6KJOFOZoOaLpKSg=";
      "eventkit-rs-0.5.6" = "sha256-MKUVpG3we93DT5N/we2bj4P3ElwbxstDRfh4y8mQ9JU=";
      "ffmpeg-sidecar-2.5.0" = "sha256-/fYkQTCAogaDfJbspQEpkVTux/yJlpSnTnS/xmYNUmE=";
      "fix-path-env-0.0.0" = "sha256-UygkxJZoiJlsgp8PLf1zaSVsJZx1GGdQyTXqaFv3oGk=";
      "hf-hub-0.3.2" = "sha256-hTAdRgJKCN4kTyZXy4SOHPEhBY4/UX+tWJPoUroKLD0=";
      "muda-0.19.2" = "sha256-bDHXDjJ2hhv4ySySZaFjLSrr5DyEom5/s4tmXuKTCRo=";
      "opf-0.1.0" = "sha256-+5s5xfXDT5GLNdBpzEQDJqq0jH3HigrN2eV/mdFYMTY=";
      "permission-flow-0.1.40" = "sha256-bTW/qFH27KUoQHi0MU8OIclFZgfnExCl+dUnugSZWDQ=";
      "rusty-tesseract-1.1.10" = "sha256-XT74zGn+DetEBUujHm4Soe2iorQcIoUeZbscTv+64hw=";
      "sck-rs-0.1.0" = "sha256-1l0RoXH+IFmdUiFHvUoPcis7FMPljBIXxk8fhEkcfTA=";
      "sonora-aec3-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
      "sonora-agc2-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
      "sonora-common-audio-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
      "sonora-fft-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
      "sonora-ns-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
      "sonora-simd-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
      "tauri-helper-0.2.1" = "sha256-WT/81iEVp+hYoDoVyWBa5FHLzSW1iQr45q9r3ifDykU=";
      "tauri-nspanel-2.0.1" = "sha256-pQgv/Lkc9yE+DSv+MdOV1NZRj2nkMhAm+Wn41qvdvvE=";
      "tauri-plugin-permission-flow-0.1.40" = "sha256-bTW/qFH27KUoQHi0MU8OIclFZgfnExCl+dUnugSZWDQ=";
      "tauri_helper_core-0.2.1" = "sha256-WT/81iEVp+hYoDoVyWBa5FHLzSW1iQr45q9r3ifDykU=";
      "tauri_helper_macros-0.1.4" = "sha256-WT/81iEVp+hYoDoVyWBa5FHLzSW1iQr45q9r3ifDykU=";
      "tinfoil-0.1.0" = "sha256-PQNNXo4v87LUsn58QJb1aT6CG8GlkvdYpFxPncuxHQw=";
      "vad-rs-0.2.0" = "sha256-kTWS74A914z3KGAjui8d9HfRKt/cJeVLcpM05W6TC+w=";
      # whisper-rs and whisper-rs-sys omitted: allowBuiltinFetchGit handles them
      # with submodules=true so whisper.cpp is present for the CMake build step.
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
    # .cargo/config.toml sets OPENBLAS_PATH=src-tauri/openblas (relative).
    # pre_build.js normally downloads openblas there; we provide system openblas instead.
    mkdir -p apps/screenpipe-app-tauri/src-tauri/openblas
    ln -s ${openblas.dev}/include apps/screenpipe-app-tauri/src-tauri/openblas/include
    ln -s ${openblas}/lib apps/screenpipe-app-tauri/src-tauri/openblas/lib
    # build.rs emits cargo:rustc-link-lib=dylib=libopenblas — the redundant "lib" prefix
    # makes the linker look for liblibopenblas.so. Patch it to just "openblas".
    sed -i 's/dylib=libopenblas/dylib=openblas/g' \
      /build/cargo-vendor-dir/antirez-asr-sys-0.1.0/build.rs
    # sck-rs's Cargo.toml references cidre without ?rev=, but the lock and vendor
    # only have the ?rev= entry. Patch the vendored Cargo.toml to match.
    sed -i \
      -e 's|git = "https://github.com/yury/cidre.git" }|git = "https://github.com/yury/cidre.git", rev = "8481f3f0dc7dd39bb5be80d9424bfac0cad3801a" }|g' \
      -e 's|git = "https://github.com/yury/cidre.git",|git = "https://github.com/yury/cidre.git", rev = "8481f3f0dc7dd39bb5be80d9424bfac0cad3801a",|g' \
      /build/cargo-vendor-dir/sck-rs-0.1.0/Cargo.toml
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
    glib-networking
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
    openblas
    ortLib
  ];

  # Use locally built frontend assets from the workspace
  frontend = stdenv.mkDerivation {
    pname = "screenpipe-frontend";
    version = "2.4.145";
    src = ./built-frontend;
    phases = [ "installPhase" ];
    installPhase = "mkdir -p $out && cp -r $src/* $out/";
  };

  preBuild = ''
    mkdir -p apps/screenpipe-app-tauri/out
    cp -r ${frontend}/* apps/screenpipe-app-tauri/out/
  '';

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  ORT_LIB_LOCATION = "${ortLib}/lib";
  ORT_STRATEGY = "system";
  ORT_PREFER_DYNAMIC_LINK = "1";
  RUSTONIG_SYSTEM_LIBONIG = "1";
  NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types -D_GNU_SOURCE";

  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin/assets
    cp -r ${src}/apps/screenpipe-app-tauri/src-tauri/assets/* $out/bin/assets/
  '';

  postFixup = ''
    wrapProgram "$out/bin/screenpipe-app" \
      --prefix PATH : ${
        lib.makeBinPath [
          bun
          tesseract
        ]
      } \
      --set GDK_BACKEND x11 \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1 \
      --set TAURI_RESOURCE_PATH "$out/bin" \
      --set GIO_EXTRA_MODULES ${glib-networking}/lib/gio/modules \
      --run 'export BUN_INSTALL="$HOME/.bun"' \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          alsa-lib
          glib
          gtk3
          libsoup_3
          webkitgtk_4_1
          glib-networking
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
        ]
      }:/run/opengl-driver/lib
  '';

  meta = with lib; {
    description = "screenpipe desktop application";
    homepage = "https://github.com/mediar-ai/screenpipe";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
