{
  inputs,
  pkgs,
  ...
}:{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    withUWSM = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    config.hyprland.default = [ "hyprland" "kde" ];
    extraPortals = with pkgs; [  ];
  };
}
