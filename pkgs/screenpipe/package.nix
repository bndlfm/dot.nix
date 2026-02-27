{ pkgs }:
let
  src = pkgs.fetchFromGitHub {
    owner = "mediar-ai";
    repo = "screenpipe";
    rev = "7b75b9ec36bb2894639f6e9852773d75772a449e";
    hash = "sha256-Qx4q1lJc+3gom/zHL+DlAXnSs8ltmgqvnBF5Q7zmc9E=";
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
in
pkgs.callPackage ./default.nix {
  inherit src cudaLibs ortLib;
  cudatoolkit = if pkgs.config.cudaSupport then pkgs.cudaPackages.cudatoolkit else null;
  stdenv = pkgs.gcc14Stdenv;
}
