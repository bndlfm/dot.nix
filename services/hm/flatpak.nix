{ ... }:{
  services = {
    flatpak = {
      packages = [
        "flathub:app/one.ablaze.floorp//stable"
        "flathub:app/net.lutris.Lutris//stable"
        "flathub:app/com.github.tchx84.Flatseal//stable"
      ];
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      };
    };
  };
}
