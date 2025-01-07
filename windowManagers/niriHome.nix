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
      clipse
      fuzzel
      swaybg
      sway-contrib.grimshot
      swaylock-fancy
      wlprop
      xwayland-satellite
    ];
  programs = {
    niri = {
      settings = {
        environment = {
          DISPLAY = ":0";
        };
        input = {
          keyboard = {
            repeat-delay = 250;
            repeat-rate = 70;
          };
        };
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
        spawn-at-startup = [
          {
            command = [ "xwayland-satellite" ":0" ];
          }
        ];
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
            "${Mod}+Shift+Plus".action = set-column-width "+10%";
            "${Mod}+Shift+Underscore".action = set-window-height "-10%";
            "${Mod}+Equal".action = set-window-height "+10%";

            "${Mod}+Shift+Escape".action = quit;
            "${Mod}+Shift+P".action = power-off-monitors;

            "${Mod}+Shift+Ctrl+T".action = toggle-debug-tint;

            "${Mod}+Left".action = focus-column-left;
            "${Mod}+Down".action = focus-window-down;
            "${Mod}+Up".action = focus-window-up;
            "${Mod}+Right".action = focus-column-right;
            "${Mod}+Home".action = focus-column-first;
            "${Mod}+End".action = focus-column-last;
            "${Mod}+Comma".action = focus-workspace-up;
            "${Mod}+Period".action = focus-workspace-down;

            "${Mod}+1".action = focus-workspace 1;
            "${Mod}+2".action = focus-workspace 2;
            "${Mod}+3".action = focus-workspace 3;
            "${Mod}+4".action = focus-workspace 4;
                  #"${Mod}+5".action = focus-workspace 5;
                  #"${Mod}+6".action = focus-workspace 6;
                  #"${Mod}+7".action = focus-workspace 7;
                  #"${Mod}+8".action = focus-workspace 8;
                  #"${Mod}+9".action = focus-workspace 9;


            "${Mod}+Shift+H".action = move-column-left-or-to-monitor-left;
            "${Mod}+Shift+N".action = move-window-down-or-to-workspace-down;
            "${Mod}+Shift+E".action = move-window-up-or-to-workspace-up;
            "${Mod}+Shift+I".action = move-column-right-or-to-monitor-right;

            "${Mod}+Shift+1".action = move-window-to-workspace 1;
            "${Mod}+Shift+2".action = move-window-to-workspace 2;
            "${Mod}+Shift+3".action = move-window-to-workspace 3;
            "${Mod}+Shift+4".action = move-window-to-workspace 4;
                  #"${Mod}+Shift+5".action = move-window-to-workspace 5;
                  #"${Mod}+Shift+6".action = move-window-to-workspace 6;
                  #"${Mod}+Shift+7".action = move-window-to-workspace 7;
                  #"${Mod}+Shift+8".action = move-window-to-workspace 8;
                  #"${Mod}+Shift+9".action = move-window-to-workspace 9;

            "${Mod}+Alt+H".action = focus-monitor-left;
            "${Mod}+Alt+N".action = focus-monitor-down;
            "${Mod}+Alt+E".action = focus-monitor-up;
            "${Mod}+Alt+I".action = focus-monitor-right;

            #"${Mod}+Alt+Ctrl".action = move-window-to-monitor;

            "${Mod}+H".action = focus-column-or-monitor-left;
            "${Mod}+N".action = focus-window-or-workspace-down;
            "${Mod}+E".action = focus-window-or-workspace-up;
            "${Mod}+I".action = focus-column-or-monitor-right;

            "${Mod}+Shift+Control+1".action = move-column-to-workspace 1;
            "${Mod}+Shift+Control+2".action = move-column-to-workspace 2;
            "${Mod}+Shift+Control+3".action = move-column-to-workspace 3;
            "${Mod}+Shift+Control+4".action = move-column-to-workspace 4;

                  #"${Mod}+Shift+Control+5".action = move-column-to-workspace 5;
                  #"${Mod}+Shift+Control+6".action = move-column-to-workspace 6;
                  #"${Mod}+Shift+Control+7".action = move-column-to-workspace 7;
                  #"${Mod}+Shift+Control+8".action = move-column-to-workspace 8;
                  #"${Mod}+Shift+Control+9".action = move-column-to-workspace 9;

          };
          window-rules = let
            colors = config.lib.stylix.colors.withHashtag;
          in [
            {
              draw-border-with-background = false;
              geometry-corner-radius = let
                r = 8.0;
              in {
                top-left = r;
                top-right = r;
                bottom-left = r;
                bottom-right = r;
              };
              clip-to-geometry = true;
            }
            {
              matches = [{is-focused = false;}];
              opacity = 0.95;
            }
            {
              # the terminal is already transparent from stylix
              matches = [{app-id = "^kitty$";}];
              opacity = 1.0;
            }
            {
              matches = [
                {
                  app-id = "^firefox-devedition$";
                  title = "Picture-in-Picture";
                }
              ];
              opacity = 0.8;
            }
            {
              matches = [{app-id = "^niri$";}];
              opacity = 1.0;
            }
            {
              matches = [
                {
                  app-id = "^kitty$";
                  title = ''^\[oxygen\]'';
                }
              ];
              border.active.color = colors.base0B;
            }
            {
              matches = [
                {
                  app-id = "^firefox$";
                  title = "Private Browsing";
                }
              ];
              border.active.color = colors.base0E;
            }
            {
              matches = [
                {
                  app-id = "^signal$";
                }
              ];
              block-out-from = "screencast";
            }
          ];
        };
      };
    waybar = {
      enable = true;
      settings =
        [
          {
            layer="top";
            position="top";
            output = [
              "DP-1"
            ];
            include = [
              "~/.config/waybar/default_modules.json"
            ];
            height = 28;
            spacing = 3;
            modules-left = [
              "niri/workspaces"
              "hyprland/workspaces"
            ];
            modules-center = [
              "tray"
            ];
            modules-right = [
              "mpd"
              "idle_inhibitor"
              "pulseaudio"
              "cpu"
              "memory"
              "temperature"
              "clock"
            ];
          }
          {
            layer = "bottom";
            position = "top";
            output = [
              "HDMI-A-1"
              "DP-2"
            ];
            include= [
              "~/.config/waybar/default_modules.json"
            ];
            height = 30;
            spacing = 4;
            modules-left= [
              "niri/workspaces"
              "hyprland/workspaces"
            ];
            modules-center = [];
            modules-right = [
              "clock"
            ];
          }
        ];
      style = /* css */ ''
        window#waybar {
        	font-size: 16px;
        	font-family: Terminess Nerd Font;
        	background: #2e3440;
        	color: #fdf6e3;
        }

        #custom-right-arrow-dark,
        #custom-left-arrow-dark {
        	color: #1a1a1a;
        }
        #custom-right-arrow-light,
        #custom-left-arrow-light {
        	color: #292b2e;
        	background: #1a1a1a;
        }

        #workspaces,
        #clock.1,
        #clock.2,
        #clock.3,
        #pulseaudio,
        #memory,
        #cpu,
        #battery,
        #disk,
        #tray {
        	background-color: #2e3440;
        }
        #tray > .passive {
        	-gtk-icon-effect: dim;
        }
        #tray > .needs-attention {
        	-gtk-icon-effect: highlight;
        }

        #workspaces button {
        	padding: 0 2px;
        	background-color: #434c5e;
        	color: #fdf6e3;
        }
        #workspaces button.active {
        	color: #ffffff;
        	background: #5e81ac;
        }
        #workspaces button.visible:not(.active) {
        	color: #ffffff;
        	background: gray;
        }
        #workspaces button:hover {
        	box-shadow: inherit;
        	text-shadow: inherit;
        }
        #workspaces button:hover {
        	background: #1a1a1a;
        	border: #1a1a1a;
        	padding: 0 3px;
        }
        #workspaces button.visible {
        	background: gray;
        	color: #ffffff;
        }

        #pulseaudio {
        	color: #268bd2;
        }
        #memory {
        	color: #2aa198;
        }
        #cpu {
        	color: #6c71c4;
        }
        #battery {
        	color: #859900;
        }
        #disk {
        	color: #b58900;
        }

        #clock,
        #pulseaudio,
        #memory,
        #cpu,
        #battery,
        #disk {
        	padding: 0 10px;
        }
      '';
      systemd.enable = true;
    };
  };
}

