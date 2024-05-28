{ pkgs, ... }:
let
  homeDir = builtins.getEnv "HOME";
in {
    services = {
      arrpc.enable = true;
      kdeconnect = {
        enable = false;
        indicator = false;
      };
      mpd = {
        enable = true;
        musicDirectory = "${homeDir}/Music";
      };
      mpdris2 = {
        enable = true;
        mpd = {};
        multimediaKeys = true;
        notifications = true;
      };
      mpd-discord-rpc.enable = true;
      wob.enable = true;
  };
}
