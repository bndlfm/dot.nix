{pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = [
      (pkgs.callPackage ../../pkgs/proton-ge-rtsp.nix {})
    ];
  };
}
