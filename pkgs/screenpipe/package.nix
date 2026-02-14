{ pkgs }:
let
  src = pkgs.fetchFromGitHub {
    owner = "mediar-ai";
    repo = "screenpipe";
    rev = "58f26bc327b83b477396fdeddcc827d1b8a18332";
    hash = "sha256-YdFt5yK+Pp4RmUdKx0TTj5+IzGfJ7gwq9UVPcdKUGY8=";
  };

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
in
pkgs.callPackage ./default.nix {
  inherit src cudaLibs ortLib v8Lib;
  cudatoolkit = if pkgs.config.cudaSupport then pkgs.cudaPackages.cudatoolkit else null;
  stdenv = pkgs.gcc14Stdenv;
}
