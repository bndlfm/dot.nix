{
  pkgs,
  config,
  inputs,
  ...
}: let
  displays = {
    left = "HDMI-A-1";
    center = "DP-1";
    right = "HDMI-A-3";
  };
in {
    nixpkgs.overlays = [
      inputs.niri.overlays.niri
    ];
    home.packages = with pkgs; [
      clipse
      fuzzel
      (pkgs.callPackage ../pkgs/ndrop.nix {})
      swaybg
      sway-contrib.grimshot
      swaylock-fancy
      wlprop
      xwayland-satellite
    ];
  programs = {
    niri = {
      package = pkgs.niri-unstable;
      settings = {
        cursor = {
            size = 32;
            theme = "${pkgs.volantes-cursors}";
          };
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
            ## LEFT MONITOR
              "${displays.left}" = {
                enable = true;
                mode = {
                  width = 1920;
                  height = 1200;
                };
                position = {
                  x = 0;
                  y = 0;
                };
                transform.rotation = 270;
              };
            ## CENTER MONITOR
              "${displays.center}" = {
                enable = true;
                mode = {
                  width = 2560;
                  height = 1440;
                };
                position = {
                  x = 1200;
                  y = 0;
                };
                variable-refresh-rate = true;
              };
            ## RIGHT MONITOR
              "${displays.right}" = {
                enable = true;
                mode = {
                  width = 1920;
                  height = 1200;
                };
                position = {
                  x = 3760;
                  y = 0;
                };
                transform.rotation = 270;
              };
          };
          layout = {
            preset-column-widths = [
              { proportion = 1. / 4.; }
              { proportion = 1. / 2.; }
              { proportion = 3. / 4.; }
            ];
            preset-window-heights = [
              { proportion = 1. / 4.; }
              { proportion = 1. / 2.; }
              { proportion = 3. / 4.; }
            ];
          };
          workspaces = {
            "ndrop" = {};
          };

          spawn-at-startup = [
            {
              command = [ "niri" "msg" "action" "focus-workspace-down" ];
            }

            #### BLUE LIGHT FILTER AT NIGHT ####
            {
              command = [ "gammastep-indicator" "-l" "38.0628:-91.4035" "-t" "6500:4800" ];
            }

            #### BLUETOOOTH ####
            {
              command = [ "blueman-applet" ];
            }


            #### GDRIVE #####
            {
              command = [ "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse" "~/Documents/GoogleDrive/" ];
            }


            #### KDE-CONNECT #####
            {
              command = [ "${pkgs.kdePackages.kdeconnect-kde}/libexec/kdeconnect"];
            }
            {
              command = ["kdeconnect-indicator"];
            }


            #### POWER SAVINGS ####
            {
              command = [ "swayidle" "-w" "timeout 601" "'niri msg action power-off-monitors'" "timeout 600" "'swaylock -f'" "before-sleep" "'swaylock -f'" ];
            }


            #### SYNC CLIPBOARD + SAVE COPY HISTORY ####
            {
              command = [ "copyq" "--start-server" ];
            }


            ##### WALLPAPER ####
            {
              command = [ "swaybg -i ~/.nixcfg/theme/wallpapers/japan street night rain umbrella 1.png -o DP-1" ];
            }

            ####  GAMMA-INDICATOR ####
            {
              command = [ "gammastep-indicator" "-l" "38.0638:-191.4035" "-t" "6500:4500"];
            }

            #### XWAYLAND ####
            {
              command = [ "xwayland-satellite" ":0" ];
            }
            {
              command = [ "xrandr" "--output" "DP-1" "--primary" ];
            }
          ];

          binds = with config.lib.niri.actions; let
            sh = spawn "sh" "-c";
            Mod = "Mod";
              #if options.virtualization ? qemu
              #then "Alt"
              #else "Mod";
            suffixes = builtins.listToAttrs (map (n: {
              name = toString n;
              value = ["workspace" n];
            }) (range 1 9));
          in
            {
              /********
              * BASIC *
              ********/
                ## QUIT NIRI/TURN OFF MONITORS
                  "${Mod}+Shift+Escape".action = quit;
                  "${Mod}+Shift+P".action = power-off-monitors;
                  "${Mod}+L".action.spawn = "blurred-locker";

                ## CLOSE WINDOW
                  "${Mod}+Q".action.close-window = [];

                ## TERMINAL/LAUNCHER
                  "${Mod}+D".action.spawn = "fuzzel";
                  "${Mod}+BackSpace".action.spawn = "kitty";
                  "${Mod}+Grave".action.spawn = [ "ndrop" "kitty" "--class" "kitty_dropdown" ];

                ## RESTART WAYBAR/SWAYBAR
                  "${Mod}+W".action = sh (builtins.concatStringsSep "; " [
                    "systemctl --user restart waybar.service"
                    "systemctl --user restart swaybg.service"
                  ]);

              /*************
              * SCREENSHOT *
              *************/
                "${Mod}+Shift+S".action = screenshot;
                "Print".action = screenshot-screen;
                "${Mod}+Print".action = screenshot-window;

              /**********************
              * MULTIMEDIA CONTROLS *
              **********************/
                "XF86AudioRaiseVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
                "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
                "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                "XF86AudioNext".action = focus-column-right;
                "XF86AudioPrev".action = focus-column-left;

              /********************
              * WINDOW MANAGEMENT *
              ********************/
                ## CONSUME/EXPEL
                  "${Mod}+C".action.consume-window-into-column = [];
                  "${Mod}+X".action.expel-window-from-column = [];

                ## TOGGLE FLOATING/SWITCH FOCUS BETWEEN TILED AND FLOATING
                  "${Mod}+S".action = toggle-window-floating;
                  "${Mod}+Tab".action = switch-focus-between-floating-and-tiling;

                ## RESIZE WINDOWS (WIDTH RESIZES COLUMNS)
                  ## CYCLE WINDOW SIZE
                    "${Mod}+B".action = switch-preset-column-width;
                    "${Mod}+Shift+B".action = switch-preset-window-width;
                    "${Mod}+V".action = switch-preset-window-height;

                  ## MANUAL RESIZE
                    "${Mod}+Ctrl+H".action = set-window-width  "-1%";
                    "${Mod}+Ctrl+N".action = set-window-height "+1%";
                    "${Mod}+Ctrl+E".action = set-window-height "-1%";
                    "${Mod}+Ctrl+I".action = set-window-width  "+1%";

                  ## FULLSCREEN
                    "${Mod}+F".action = maximize-column;
                    "${Mod}+Shift+F".action = fullscreen-window;

                  ## COLUMN SCREEN ALIGNMENT
                    "${Mod}+Alt+C".action = center-column;

              /********
              * FOCUS *
              ********/
                ## FOCUS WITH VI KEYS (COLEMAK)
                  "${Mod}+H".action = focus-column-or-monitor-left;
                  "${Mod}+N".action = focus-window-or-workspace-down;
                  "${Mod}+E".action = focus-window-or-workspace-up;
                  "${Mod}+I".action = focus-column-or-monitor-right;

                ## FOCUS COLUMN
                  "${Mod}+Comma".action = focus-column-first;
                  "${Mod}+Period".action = focus-column-last;

                ## FOCUS MONITOR
                  "${Mod}+Left".action = focus-monitor-left;
                  "${Mod}+Down".action = focus-monitor-down;
                  "${Mod}+Up".action = focus-monitor-up;
                  "${Mod}+Right".action = focus-monitor-right;

                ## FOCUS WORKSPACE
                  "${Mod}+1".action = focus-workspace 1;
                  "${Mod}+2".action = focus-workspace 2;
                  "${Mod}+3".action = focus-workspace 3;
                  "${Mod}+4".action = focus-workspace 4;

              /*********************
              * MOVE WINDOW/COLUMN *
              *********************/
                ## MOVE COLUMN/WINDOW WITH VI KEYS
                  "${Mod}+Shift+H".action = move-column-left-or-to-monitor-left;
                  "${Mod}+Shift+N".action = move-window-down-or-to-workspace-down;
                  "${Mod}+Shift+E".action = move-window-up-or-to-workspace-up;
                  "${Mod}+Shift+I".action = move-column-right-or-to-monitor-right;

                ## MOVE WINDOW TO WORKSPACE
                  "${Mod}+Shift+1".action = move-window-to-workspace 1;
                  "${Mod}+Shift+2".action = move-window-to-workspace 2;
                  "${Mod}+Shift+3".action = move-window-to-workspace 3;
                  "${Mod}+Shift+4".action = move-window-to-workspace 4;

                ## MOVE COLUMN TO WORKSPACE
                  "${Mod}+Shift+Control+1".action = move-column-to-workspace 1;
                  "${Mod}+Shift+Control+2".action = move-column-to-workspace 2;
                  "${Mod}+Shift+Control+3".action = move-column-to-workspace 3;
                  "${Mod}+Shift+Control+4".action = move-column-to-workspace 4;
            };


              window-rules = let
                colors = config.lib.stylix.colors.withHashtag;
              in [
                ## ROUNDED CORNERS
                {
                  draw-border-with-background = false;
                  geometry-corner-radius =
                    let
                      r = 8.0;
                    in {
                      top-left = r;
                      top-right = r;
                      bottom-left = r;
                      bottom-right = r;
                    };
                  clip-to-geometry = true;
                }

                ## DRAW UNFOCUSED WITH 90% OPACITY
                {
                  matches = [
                    {
                      is-focused = false;
                    }
                  ];
                  opacity = 0.98;
                }

                ## MAKE MPV OPAQUE
                {
                  matches = [
                    {
                      is-focused = false;
                      app-id = "mpv";
                    }
                  ];
                  opacity = 1.0;
                }

                ## FLOAT FF PIP
                {
                  matches = [
                    {
                      app-id = "^firefox-devedition$";
                      title = "^Picture-in-Picture$";
                    }
                  ];
                  opacity = 0.9;
                  open-floating = true;
                  default-column-width.fixed = 425;
                  default-window-height.fixed = 250;
                  default-floating-position = {
                    relative-to = "top-right";
                    x = 75;
                    y = 50;
                  };
                }

                ## KITTY DROPDOWN
                {
                  matches = [
                    { app-id = "^kitty_dropdown$"; }
                  ];
                  open-floating = true;
                }

                ## HIGHLIGHT PRIVATE BROWSING
                {
                  matches = [
                    {
                      app-id = "^firefox$";
                      title = "Private Browsing";
                    }
                  ];
                  border.active.color = colors.base0E;
                }

                ## PREVENT SCREEN CAPTURE OF SENSITIVE APPS
                {
                  matches = [
                    {
                      app-id = "^signal$";
                    }
                  ];
                  block-out-from = "screencast";
                }

                ## GUESSING THIS PREVENTS NIRI WM FROM BEING TRANSPARENT?
                {
                  matches = [{app-id = "^niri$";}];
                  opacity = 1.0;
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
              "${displays.center}"
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
              "${displays.left}"
              "${displays.right}"
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
