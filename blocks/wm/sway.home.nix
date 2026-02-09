{ pkgs, ...}:{
  home.sessionVariables = {
    WLR_RENDERER="vulkan";
  };
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    mako
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      output = {
        "ASUSTek COMPUTER INC ASUS VG32V 0x0000CE0E (DP-1)" = {
          mode = "2560x1440@144Hz";
        };
      };
      startup = [
        {command = "firefox-devedition";}
        ];
      };
      extraConfig = ''
        bindsym XF86AudioRaiseVolume exec 'pactl sent-sink-volume @DEFAULT_SINK@ +1%'
      '';
    };
}
