{ pkgs }:
let
  src = pkgs.fetchFromGitHub {
    owner = "mediar-ai";
    repo = "screenpipe";
    rev = "137cc439b3a7e2533d002f5411493cf351f6aae4";
    hash = "sha256-FUPVtUVfFqLrdzt2Z2mXjDxSluYm+4ymYEUbNcXS23w=";
  };

  cudaLibs = pkgs.lib.optionals pkgs.config.cudaSupport (
    with pkgs.cudaPackages;
    [
      cudatoolkit
      cuda_cudart
      cuda_nvcc
      cccl
      libcublas
    ]
  );

  ortLib = pkgs.onnxruntime.override { cudaSupport = false; };
in
pkgs.callPackage ./default.nix {
  inherit src cudaLibs ortLib;
  cudatoolkit = if pkgs.config.cudaSupport then pkgs.cudaPackages.cudatoolkit else null;
  stdenv = pkgs.gcc14Stdenv;
}
