{ pkgs, ... }:
let
  homeDir = builtins.getEnv "HOME";
in {
  services = {
    arrpc.enable = true;
    espanso = {
      enable = true;
      package = pkgs.espanso;
      matches = {
        base = {
          matches = [
            { trigger = ":fflb"; replace = "firefliesandlightningbugs@gmail.com"; }
          ];
        };
      };
    };
    #espanso-wayland = {
    #  enable = true;
    #  package = pkgs.espanso-wayland;
    #  matches = {
    #    base = {
    #      matches = [
    #        { trigger = ":fflb"; replace = "firefliesandlightningbugs@gmail.com"; }
    #      ];
    #    };
    #  };
    #};
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    mpd = {
      enable = true;
      musicDirectory = "${homeDir}/Music";
      };
    mpdris2 = {
      enable = true;
      mpd = {
        password = "8u55y";
      };
      multimediaKeys = true;
      notifications = true;
    };
    mpd-discord-rpc.enable = true;
    wob.enable = true;
  };
}
