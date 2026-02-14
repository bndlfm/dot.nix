{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    screenpipe-src.url = "github:mediar-ai/screenpipe";
    screenpipe-src.flake = false;
  };

  outputs = { flake-utils, nixpkgs, screenpipe-src, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = false;
          };
        };
        rustPlatform = pkgs.makeRustPlatform {
          cargo = pkgs.cargo;
          rustc = pkgs.rustc;
        };

        src = screenpipe-src;

        cudaLibs = pkgs.lib.optionals pkgs.config.cudaSupport (with pkgs.cudaPackages; [
          cudatoolkit
          cuda_cudart
          cuda_nvcc
          cuda_cccl
          libcublas
        ]);

        ortPrebuilt = pkgs.fetchurl {
          url = "https://parcel.pyke.io/v2/delivery/ortrs/packages/msort-binary/1.19.2/ortrs_static-v1.19.2-x86_64-unknown-linux-gnu.tgz";
          hash = "sha256-xxjv6Wd+CTvNmGon6+g73dDa/Wln+vsN4xGiOdJ/SnE=";
        };
        ortLib = pkgs.stdenvNoCC.mkDerivation {
          pname = "ort-prebuilt";
          version = "1.19.2";
          src = ortPrebuilt;
          phases = [ "unpackPhase" "installPhase" ];
          unpackPhase = ''
            mkdir -p "$out"
            tar xzf "$src" --strip-components=1 -C "$out"
          '';
          installPhase = "true";
        };

        v8Prebuilt = pkgs.fetchurl {
          url = "https://github.com/denoland/rusty_v8/releases/download/v0.106.0/librusty_v8_release_x86_64-unknown-linux-gnu.a.gz";
          hash = "sha256-jLYl/CJp2Z+Ut6qZlh6u+CtR8KN+ToNTB+72QnVbIKM=";
        };
        v8Lib = pkgs.stdenvNoCC.mkDerivation {
          pname = "rusty-v8-prebuilt";
          version = "0.106.0";
          src = v8Prebuilt;
          phases = [ "unpackPhase" "installPhase" ];
          unpackPhase = ''
            mkdir -p "$out/lib"
            gzip -d < "$src" > "$out/lib/librusty_v8.a"
          '';
          installPhase = "true";
        };

        screenpipeBundle = pkgs.callPackage ./default.nix {
          inherit src cudaLibs ortLib v8Lib rustPlatform;
          cudatoolkit = if pkgs.config.cudaSupport then pkgs.cudaPackages.cudatoolkit else null;
          stdenv = pkgs.gcc14Stdenv;
        };
        screenpipeBackend = screenpipeBundle.screenpipe-backend;
        screenpipeApp = screenpipeBundle.screenpipe-app;
      in {
        packages = rec {
          screenpipe-backend = screenpipeBackend;
          screenpipe-cli = screenpipeBackend;
          screenpipe-app = screenpipeApp;
          build-all = pkgs.symlinkJoin {
            name = "screenpipe-all";
            paths = [
              screenpipe-backend
              screenpipe-cli
              screenpipe-app
            ];
          };
          screenpipe = screenpipeBundle;
          default = screenpipe;
        };

        defaultPackage = screenpipeBackend;

        apps.default = flake-utils.lib.mkApp {
          drv = screenpipeBackend;
          name = "screenpipe";
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ screenpipeBackend screenpipeApp ];
          packages = with pkgs; [
            cargo
            rustc
            bun
            nodejs_20
          ];
        };
      });
}
#        packages.zzzscreenpipe-app-frontend = pkgs.stdenv.mkDerivation {
#          pname = "screenpipe-app-frontend";
#          version = "1.89.0";
#          src = ./screenpipe-app-tauri;
#          buildInputs = [
#            pkgs.bun
#            pkgs.nodejs
#            ];
#          buildPhase = ''
#            bun install
#            bun tauri build
#            '';
#          installPhase = ''
#            mkdir -p $out/bin
#            cp -r src-tauri/target/release/bundle $out/bin
#            '';
#          };
#
