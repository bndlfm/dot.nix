{ pkgs, ... }: {
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs; [
      { package = gnomeExtensions.paperwm; }
      { package = gnomeExtensions.gsconnect; }
    ];
  };
}
