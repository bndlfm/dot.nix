{
  nixpkgs,
  config,
  inputs,
  ...
}:
let
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
in {
    nixpkgs.overlays = [
      inputs.niri.overlays.niri
    ];
    programs.niri = {
      enable = true;
      settings = {
        outputs = {
          "DP-1" = {
            enable = true;
            mode = {
              width = 2560;
              height = 1440;
              refresh = 144;
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
              refresh = 60;
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
          theme = pkgs.volantes-cursors;
        };
        binds = with config.lib.niri.actions; let
          sh = spawn "sh" "-c";
          Mod = if nixosConfig.is-virtual-machine
            then "Alt"
            else "Mod";
        in
          pkgs.lib.attrsets.mergeAttrsList [
          {
            "${Mod}+Enter".action = spawn "kitty";
            "${Mod}+D".action = spawn "fuzzel";
            "${Mod}+W".action = sh (builtins.concatStringsSep "; " [
              "systemctl --user restart waybar.service"
              "systemctl --user restart swaybg.service"
            ]);
            "${Mod}+L".action = spawn "blurred-locker";

            "${Mod}+Shift+S".action = screenshot;
            "Print".action = screenshot-screen;
            "${Mod}+Print".action = screenshot-window;

            "XF86AudioRaiseVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
            "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
            "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

            "${Mod}+Q".action = close-window;

            "XF86AudioNext".action = focus-column-right;
            "XF86AudioPrev".action = focus-column-left;

            "${Mod}+Tab".action = focus-window-down-or-column-right;
            "${Mod}+Shift+Tab".action = focus-window-up-or-column-left;
          }
          (binds {
            suffixes."Left" = "column-left";
            suffixes."Down" = "window-down";
            suffixes."Up" = "window-up";
            suffixes."Right" = "column-right";
            prefixes."${Mod}" = "focus";
            prefixes."${Mod}+Ctrl" = "move";
            prefixes."${Mod}+Shift" = "focus-monitor";
            prefixes."${Mod}+Shift+Ctrl" = "move-window-to-monitor";
            substitutions."monitor-column" = "monitor";
            substitutions."monitor-window" = "monitor";
          })
          (binds {
            suffixes."Home" = "first";
            suffixes."End" = "last";
            prefixes."${Mod}" = "focus-column";
            prefixes."${Mod}+Ctrl" = "move-column-to";
          })
          (binds {
            suffixes."U" = "workspace-down";
            suffixes."I" = "workspace-up";
            prefixes."${Mod}" = "focus";
            prefixes."${Mod}+Ctrl" = "move-window-to";
            prefixes."${Mod}+Shift" = "move";
          })
          (binds {
            suffixes = builtins.listToAttrs (map (n: {
              name = toString n;
              value = ["workspace" n];
            }) (range 1 9));
            prefixes."${Mod}" = "focus";
            prefixes."${Mod}+Ctrl" = "move-window-to";
          })
          {
            "${Mod}+Comma".action = consume-window-into-column;
            "${Mod}+Period".action = expel-window-from-column;

            "${Mod}+R".action = switch-preset-column-width;
            "${Mod}+F".action = maximize-column;
            "${Mod}+Shift+F".action = fullscreen-window;
            "${Mod}+C".action = center-column;

            "${Mod}+Minus".action = set-column-width "-10%";
            "${Mod}+Plus".action = set-column-width "+10%";
            "${Mod}+Shift+Minus".action = set-window-height "-10%";
            "${Mod}+Shift+Plus".action = set-window-height "+10%";

            "${Mod}+Shift+E".action = quit;
            "${Mod}+Shift+P".action = power-off-monitors;

            "${Mod}+Shift+Ctrl+T".action = toggle-debug-tint;
          }
        ];
      };
    };
}

