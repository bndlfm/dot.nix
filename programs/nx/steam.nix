{pkgs, ... }:
{
  programs.steam.extraCompatPackages = [
    (pkgs.callPackage ../../packages/proton-ge-rtsp.nix {})
  ];
}
