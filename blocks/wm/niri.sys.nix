{
  pkgs,
  inputs,
  ...
}:
{
  # Enable overlays for Niri
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  # Enable and set the package for Niri
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  xdg.portal.config.niri.default = [
    "kde"
    "hyprland"
  ];
}
