{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.wm.autostart = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "List of commands to execute on startup for the window managers.";
  };

  config = {
    wm.autostart = [
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE"
      "waypaper --restore"
      "swaync"
      "vicinae server"
      "waybar"
      "${pkgs.kdePackages.kdeconnect-kde}/libexec/kdeconnect"
      "kdeconnect-indicator"
      "blueman-applet"
      #"homeassistant-desktop"
      "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse /home/neko/Documents/GoogleDrive/"
      "trayscale --hide-window"
      "xrandr --output DP-1 --primary"
      "sunshine"
    ];
  };
}
