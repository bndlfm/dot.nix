{ ... }:{
  services = {
    flatpak = {
      packages = [
        "com.discordapp.Discord"
	"com.google.EarthPro"
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
