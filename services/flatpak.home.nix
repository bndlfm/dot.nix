{ ... }:{
  services = {
    flatpak = {
      enable = true;
      packages = [
	"com.google.EarthPro"
        "com.github.tchx84.Flatseal"
        "org.jdownloader.JDownloader"
      ];
      uninstallUnmanaged = true;
      update = {
        auto = {
          enable = true;
          onCalendar = "weekly";
        };
        onActivation = true;
      };
    };
  };
}
