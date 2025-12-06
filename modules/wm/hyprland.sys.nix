{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    withUWSM = true;
    xwayland.enable = true;
  };
}
