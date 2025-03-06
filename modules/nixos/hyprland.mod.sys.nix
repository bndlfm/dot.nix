{inputs, config, pkgs, lib, ... }:{
  options = {
    _hyprland.enable = lib.mkEnableOption "Enable Neko's Hyprland NixOS Config";
  };
  config = lib.mkIf config._hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      withUWSM = true;
      xwayland.enable = true;
    };
  };
}
