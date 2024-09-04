{ niri, ... }:{
  programs.niri = {
    settings = {
      #binds = with niri.config.lib.niri.actions; let
      #  sh = spawn "sh" "-c";
      #in {
      #  "Mod+h".action = focus-column-or-monitor-left;
      #  "Mod+n".action = focus-window-or-monitor-down;
      #  "Mod+e".action = focus-window-or-monitor-up;
      #  "Mod+i".action = focus-column-or-monitor-right;
      #  "Mod+o".action = consume-or-expel-window-left;
      #  "Mod+O".action = consume-or-expel-window-right;

      #  "Mod+c".action = center-column;
      #  "Mod+C".action = consume-window-into-column;
      #  "Mod+x".action = expel-window-from-column;

      #  "Print".action = sh ''grim -g "$(slurp)" - | wl-copy'';

      #  "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
      #  "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";

      #  "Mod+D".action = spawn "wofi" "--show run";
      #  "Mod+1".action = focus-workspace 1;
      #  "Mod+2".action = focus-workspace 2;
      #  "Mod+3".action = focus-workspace 3;
      #  "Mod+4".action = focus-workspace 4;
      #  "Mod+5".action = focus-workspace 5;
      #  "Mod+6".action = focus-workspace 6;
      #  "Mod+7".action = focus-workspace 7;
      #  "Mod+8".action = focus-workspace 8;
      #  "Mod+9".action = focus-workspace 9;
      #  "Mod+0".action = focus-workspace 0;

      #  "Mod+Shift+E".action = quit;
      #  "Mod+Ctrl+Shift+E".action = quit { skip-confirmation=true; };

      #  "Mod+Plus".action = set-column-width "+10%";
      #  "Mod+Minus".action = set-column-width "-10%";
      #  };
      input = {};
      layout = {
        gaps = 10;
        struts = {
          left = 10;
          right = 10;
          top = 10;
          bottom = 10;
          };
        };
      outputs = {
        "DP-1" = {
          enable = true;
          position = {
            x = 1080;
            y = 0;
          };
        };
        "DP-2" = {
          enable = true;
          position = {
            x = 3640;
            y = 0;
          };
          transform.rotation = 270;
        };
        "HDMI-A-1" = {
          enable = true;
          position = {
            x = 0;
            y = 0;
          };
          transform.rotation = 270;
        };
      };
      workspaces = {};
    };
  };
}
