{ pkgs }:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/m1k1o/neko/nvidia-firefox";
  imageDigest = "sha256:06bfbc4f3775c7b36a1248ad1e1a57c897d3c5e3c38454632320eced0d2f1b78";
  sha256 = "sha256-2NZ37MpSHvo/HqgbMhPAB19goPLRClP83BBXCjlWm1w=";
  finalImageName = "vrchat-neko-nvenc";
  finalImageTag = "3.1.5";
}
