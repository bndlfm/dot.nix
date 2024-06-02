{ ... }:{
  services = {
    flatpak = {
      packages = [
        "flathub:app/com.github.tchx84.Flatseal"
        "flathub:app/one.ablaze.floorp"
        "flathub:app/com.google.EarthPro"
        "flathub:app/net.lutris.Lutris"
      ];
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      };
    };
  };
}
