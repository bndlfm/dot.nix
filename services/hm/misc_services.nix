{ pkgs, ... }:
let
  homeDir = builtins.getEnv "HOME";
in {
  services = {
    arrpc.enable = true;
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    mpd = {
      enable = false;
      musicDirectory = "${homeDir}/Music";
    };
    mpdris2 = {
      enable = false;
      mpd = {};
      multimediaKeys = true;
      notifications = true;
    };
    mpd-discord-rpc.enable = true;
    wob.enable = true;
  };
}
