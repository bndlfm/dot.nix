{ pkgs, ... }: {
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs; [
      #{ package = gnomeExtensions.paperwm; }
      { package = gnomeExtensions.dash-to-panel; }
      { package = gnomeExtensions.tray-icons-reloaded; }
      { package = gnomeExtensions.gsconnect; }
    ];
  };
}
