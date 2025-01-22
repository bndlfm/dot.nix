{ pkgs, ... }:{
  programs.rofi = {
    enable = false;
    #cycle = true;
    #font = "Inconsolata Nerd Font 12";
    #location = "center";
    package = pkgs.rofi-wayland-unwrapped;
    plugins = with pkgs; [
      rofi-pass-wayland
      #rofi-calc
      #rofi-pulse-select
      #rofi-systemd
      #rofi-top
      #rofi-bluetooth
      #rofi-file-browser
      #rofi-menugen
      #rofi-power-menu
      #rofi-obsidian
    ];
  };
}
