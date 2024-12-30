{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
    nixpkgs.overlays = [
      inputs.niri.overlays.niri
    ];
    home.packages = with pkgs; [
      xwayland-satellite
    ];
    programs.niri = {
      settings = {
        outputs = {
          "DP-1" = {
            enable = true;
            mode = {
              width = 2560;
              height = 1440;
            };
            position = {
              x = 1080;
              y = 0;
            };
            variable-refresh-rate = true;
          };
          "DP-2" = {
            enable = true;
            mode = {
              width = 1920;
              height = 1080;
            };
            position = {
              x = 3640;
              y = 0;
            };
            transform.rotation = 270;
          };
        };
        cursor = {
          size = 32;
          theme = "${pkgs.volantes-cursors}";
        };
        binds = with config.lib.niri.actions; let
          Mod = "Mod";
          suffixes = builtins.listToAttrs (map (n: {
            name = toString n;
            value = ["workspace" n];
          }) (range 1 9));
        in
          {
            "${Mod}+T".action.spawn = "kitty";
            "${Mod}+D".action.spawn = "fuzzel";
            "${Mod}+Q".action.close-window = [];

            #"${Mod}+W".action.spawn = "sh -c" (builtins.concatStringsSep "; " [
            #  "systemctl --user restart waybar.service"
            #  "systemctl --user restart swaybg.service"
            #]);

            "${Mod}+L".action.spawn = "blurred-locker";


            "${Mod}+Shift+S".action = screenshot;
            "Print".action = screenshot-screen;
            "${Mod}+Print".action = screenshot-window;


            "XF86AudioRaiseVolume".action.spawn = "sh -c wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
            "XF86AudioLowerVolume".action.spawn = "sh -c wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
            "XF86AudioMute".action.spawn = "sh -c wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "XF86AudioNext".action = focus-column-right;
            "XF86AudioPrev".action = focus-column-left;


            "${Mod}+Tab".action = focus-window-down-or-column-right;
            "${Mod}+Shift+Tab".action = focus-window-up-or-column-left;

            "${Mod}+C".action.consume-window-into-column = [];
            "${Mod}+X".action.expel-window-from-column = [];

            "${Mod}+R".action = switch-preset-column-width;
            "${Mod}+F".action = maximize-column;
            "${Mod}+Shift+F".action = fullscreen-window;
            "${Mod}+Alt+C".action = center-column;

            "${Mod}+Minus".action = set-column-width "-10%";
            "${Mod}+Plus".action = set-column-width "+10%";
            "${Mod}+Shift+Minus".action = set-window-height "-10%";
            "${Mod}+Shift+Plus".action = set-window-height "+10%";

            "${Mod}+Shift+Escape".action = quit;
            "${Mod}+Shift+P".action = power-off-monitors;

            "${Mod}+Shift+Ctrl+T".action = toggle-debug-tint;

            "${Mod}+Left".action = focus-column-left;
            "${Mod}+Down".action = focus-window-down;
            "${Mod}+Up".action = focus-window-up;
            "${Mod}+Right".action = focus-column-right;
            "${Mod}+Home".action = focus-column-first;
            "${Mod}+End".action = focus-column-last;
            "${Mod}+Comma".action = focus-workspace-down;
            "${Mod}+Period".action = focus-workspace-up;

            "${Mod}+Alt+1".action = focus-workspace 1;
            "${Mod}+Alt+2".action = focus-workspace 2;
            "${Mod}+Alt+3".action = focus-workspace 3;
            "${Mod}+Alt+4".action = focus-workspace 4;
            "${Mod}+Alt+5".action = focus-workspace 5;
            "${Mod}+Alt+6".action = focus-workspace 6;
            "${Mod}+Alt+7".action = focus-workspace 7;
            "${Mod}+Alt+8".action = focus-workspace 8;
            "${Mod}+Alt+9".action = focus-workspace 9;


            "${Mod}+Shift+H".action = move-column-left-or-to-monitor-left;
            "${Mod}+Shift+N".action = move-window-down-or-to-workspace-down;
            "${Mod}+Shift+E".action = move-window-up-or-to-workspace-up;
            "${Mod}+Shift+I".action = move-column-right-or-to-monitor-right;

            "${Mod}+Shift+1".action = move-window-to-workspace 1;
            "${Mod}+Shift+2".action = move-window-to-workspace 2;
            "${Mod}+Shift+3".action = move-window-to-workspace 3;
            "${Mod}+Shift+4".action = move-window-to-workspace 4;
            "${Mod}+Shift+5".action = move-window-to-workspace 5;
            "${Mod}+Shift+6".action = move-window-to-workspace 6;
            "${Mod}+Shift+7".action = move-window-to-workspace 7;
            "${Mod}+Shift+8".action = move-window-to-workspace 8;
            "${Mod}+Shift+9".action = move-window-to-workspace 9;

            "${Mod}+Alt+H".action = focus-monitor-left;
            "${Mod}+Alt+N".action = focus-monitor-down;
            "${Mod}+Alt+E".action = focus-monitor-up;
            "${Mod}+Alt+I".action = focus-monitor-right;

            #"${Mod}+Alt+Ctrl".action = move-window-to-monitor;

            "${Mod}+H".action = focus-column-or-monitor-left;
            "${Mod}+N".action = focus-window-or-monitor-down;
            "${Mod}+E".action = focus-window-or-monitor-up;
            "${Mod}+I".action = focus-column-or-monitor-right;

            "${Mod}+Shift+Alt+1".action = move-column-to-workspace 1;
            "${Mod}+Shift+Alt+2".action = move-column-to-workspace 2;
            "${Mod}+Shift+Alt+3".action = move-column-to-workspace 3;
            "${Mod}+Shift+Alt+4".action = move-column-to-workspace 4;
            "${Mod}+Shift+Alt+5".action = move-column-to-workspace 5;
            "${Mod}+Shift+Alt+6".action = move-column-to-workspace 6;
            "${Mod}+Shift+Alt+7".action = move-column-to-workspace 7;
            "${Mod}+Shift+Alt+8".action = move-column-to-workspace 8;
            "${Mod}+Shift+Alt+9".action = move-column-to-workspace 9;

            #"Mod" = "focus";
            #"Mod+Ctrl" = "move-window-to";
            #"Mod+Shift" = "move";
            #"Mod" = "focus";
            #"Mod+Ctrl" = "move-window-to";
          };
      };
    };
}

