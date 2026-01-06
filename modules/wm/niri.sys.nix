{ niri, ... }@inputs:{
  # Enable overlays for Niri
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  # Enable and set the package for Niri
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.x86_64-linux.niri-unstable;
  };
  xdg.portal.config.niri.default = [ "gtk" "kde" ];
}
