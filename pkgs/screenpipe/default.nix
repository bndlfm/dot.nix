{
  lib,
  stdenv,
  rustPlatform,
  pkg-config,
  cmake,
  makeWrapper,
  autoPatchelfHook,
  addDriverRunpath,
  callPackage,
  symlinkJoin,
  alsa-lib,
  atk,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gtk3,
  libsoup_3,
  llvmPackages,
  libgbm,
  mesa,
  oniguruma,
  openssl,
  pango,
  webkitgtk_4_1,
  glib-networking,
  pipewire,
  xdotool,
  libxi,
  libxcb,
  libxtst,
  libpulseaudio,
  ffmpeg,
  sqlite,
  bun,
  tesseract,
  cudatoolkit ? null,
  src,
  cudaLibs,
  ortLib,
}:
let
  rootLock = builtins.readFile "${src}/Cargo.lock";
  filteredRootLock =
    lib.replaceStrings
      [
        # Remove duplicate cidre-0.15.1 without ?rev= (same commit as the ?rev= entry,
        # causes cargo-vendor-dir symlink collision on second ln -s of same name)
        ''
          [[package]]
          name = "cidre"
          version = "0.15.1"
          source = "git+https://github.com/yury/cidre.git#8481f3f0dc7dd39bb5be80d9424bfac0cad3801a"
          dependencies = [
           "cc",
           "cidre-macros 0.5.0",
           "half",
           "parking_lot",
           "tokio",
          ]

        ''
        # sck-rs dep reference to cidre without ?rev= — redirect to the explicit ?rev= entry
        " \"cidre 0.15.1 (git+https://github.com/yury/cidre.git)\","
      ]
      [
        ""
        " \"cidre 0.15.1 (git+https://github.com/yury/cidre.git?rev=8481f3f0dc7dd39bb5be80d9424bfac0cad3801a)\","
      ]
      rootLock;

  backend = rustPlatform.buildRustPackage (
    {
      pname = "screenpipe-backend";
      version = "0.4.25";

      inherit src;

      cargoLock = {
        lockFileContents = filteredRootLock;
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
          "hf-hub-0.3.2" = "sha256-hTAdRgJKCN4kTyZXy4SOHPEhBY4/UX+tWJPoUroKLD0=";
          "opf-0.1.0" = "sha256-+5s5xfXDT5GLNdBpzEQDJqq0jH3HigrN2eV/mdFYMTY=";
          "rusty-tesseract-1.1.10" = "sha256-XT74zGn+DetEBUujHm4Soe2iorQcIoUeZbscTv+64hw=";
          "sck-rs-0.1.0" = "sha256-1l0RoXH+IFmdUiFHvUoPcis7FMPljBIXxk8fhEkcfTA=";
          "sonora-aec3-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
          "sonora-agc2-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
          "sonora-common-audio-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
          "sonora-fft-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
          "sonora-ns-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
          "sonora-simd-0.1.0" = "sha256-qFFPUsAUem6ASaac55VYkvJ7/EzoPRZgI0IAzskbghA=";
          "tinfoil-0.1.0" = "sha256-PQNNXo4v87LUsn58QJb1aT6CG8GlkvdYpFxPncuxHQw=";
          "vad-rs-0.2.0" = "sha256-kTWS74A914z3KGAjui8d9HfRKt/cJeVLcpM05W6TC+w=";
          # whisper-rs and whisper-rs-sys omitted: allowBuiltinFetchGit handles them
          # with submodules=true so whisper.cpp is present for the CMake build step.
        };
      };

      cargoBuildFlags = [
        "-p"
        "screenpipe-engine"
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
      ]
      ++ cudaLibs;

      buildInputs = [
        alsa-lib
        atk
        cairo
        dbus
        gdk-pixbuf
        glib
        gtk3
        libsoup_3
        glib-networking
        llvmPackages.clang
        llvmPackages.libclang
        libgbm
        mesa
        oniguruma
        openssl
        ortLib
        pango
        pipewire
        webkitgtk_4_1
        xdotool
        libxi
        libxcb
        libxtst
        libpulseaudio
      ]
      ++ cudaLibs;

      propagatedBuildInputs = [
        ffmpeg
        sqlite
        tesseract
      ]
      ++ cudaLibs;

      LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
      ORT_LIB_LOCATION = "${ortLib}/lib";
      ORT_STRATEGY = "system";
      ORT_PREFER_DYNAMIC_LINK = "1";
      RUSTONIG_SYSTEM_LIBONIG = "1";
      NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types -D_GNU_SOURCE";
      NIX_LDFLAGS = lib.optionalString (cudatoolkit != null) "-L${cudatoolkit}/lib/stubs";

      autoPatchelfIgnoreMissingDeps = [ "libcuda.so.1" ];

      doCheck = false;

      postPatch = ''
        cp /build/cargo-vendor-dir/Cargo.lock Cargo.lock
        # sck-rs's Cargo.toml references cidre without ?rev=, but the lock and vendor
        # only have the ?rev= entry. Patch the vendored Cargo.toml to match.
        sed -i \
          -e 's|git = "https://github.com/yury/cidre.git" }|git = "https://github.com/yury/cidre.git", rev = "8481f3f0dc7dd39bb5be80d9424bfac0cad3801a" }|g' \
          -e 's|git = "https://github.com/yury/cidre.git",|git = "https://github.com/yury/cidre.git", rev = "8481f3f0dc7dd39bb5be80d9424bfac0cad3801a",|g' \
          /build/cargo-vendor-dir/sck-rs-0.1.0/Cargo.toml
      '';

      postFixup = ''
        wrapProgram "$out/bin/screenpipe" \
          --set GIO_EXTRA_MODULES ${glib-networking}/lib/gio/modules \
          --run 'export BUN_INSTALL="$HOME/.bun"' \
          --prefix PATH : ${
            lib.makeBinPath [
              bun
              tesseract
            ]
          } \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath (cudaLibs ++ [ ortLib ])}:/run/opengl-driver/lib
      '';

      meta = with lib; {
        description = "screenpipe backend and CLI";
        homepage = "https://github.com/mediar-ai/screenpipe";
        license = licenses.mit;
        platforms = platforms.linux;
      };
    }
    // lib.optionalAttrs (cudatoolkit != null) {
      CUDA_PATH = "${cudatoolkit}";
      CUDA_ROOT = "${cudatoolkit}";
      CUDA_TOOLKIT_ROOT_DIR = "${cudatoolkit}";
    }
  );

  app = callPackage ./apps/screenpipe-app-tauri/default.nix {
    inherit
      src
      ortLib
      rustPlatform
      glib-networking
      ;
  };
in
symlinkJoin {
  name = "screenpipe";
  paths = [
    backend
    app
  ];
  passthru = {
    screenpipe-backend = backend;
    screenpipe-app = app;
  };
}
