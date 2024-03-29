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
      flatpak = {
        packages = [
          "flathub:app/org.qutebrowser.qutebrowser//stable"
          "flathub:app/org.qutebrowser.qutebrowser.Userscripts//stable"
          "flathub:app/net.lutris.Lutris//stable"
          "flathub:app/com.github.tchx84.Flatseal//stable"
          "flathub:app/app.getclipboard.Clipboard//stable"
          "flathub:app/md.obsidian.Obsidian//stable"
          "flathub:app/com.discordapp.Discord//stable"
        ];
        remotes = {
          "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
          "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
          };
        };
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
