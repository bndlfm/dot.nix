{inputs, config, pkgs, lib, ... }:{
  options = {
    neko.hyprland.enable = lib.mkEnableOption "Enable Neko's Hyprland NixOS Config";
  };
  config = lib.mkIf config.neko.hyprland.enable {
    nixos.programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        withUWSM = true;
        xwayland.enable = true;
    };
  };
}
