{ ... }:{
  services = {
    flatpak = {
      packages = [
        "com.discordapp.Discord"
        #"one.ablaze.floorp"
        "net.lutris.Lutris"
        "com.github.tchx84.Flatseal"
      ];
      uninstallUnmanaged = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };
}
