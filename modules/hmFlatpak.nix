{ flatpak, ...}:{
services = {
  flatpak = {
    packages = [
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
  };
}
