{
  pkgs,
  config,
  inputs,
  ...
}:
let
  _g = import ../../lib/globals.nix { inherit config; };
in
{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  imports = [
    ../../mod/nyarch-assistant.home.nix
  ];

  home.packages = with pkgs; [
    clipse
    fuzzel
    swaybg
    swayidle
    swaylock-effects
    quickshell
    wlprop
  ];

  gtk = {
    cursorTheme = {
      package = pkgs.volantes-cursors;
      name = "volantes_light_cursors";
    };
  };

  programs = {
    niri = {
      package = pkgs.niri-unstable;
      settings = {
        cursor = {
          size = 32;
          theme = "volantes_light_cursors";
        };

        xwayland-satellite = {
          enable = true;
          path = pkgs.lib.getExe pkgs.xwayland-satellite-unstable;
        };

        environment = {
          NIXOS_OZONE_WL = "1"; # fixes electron wayland
          ELECTRON_OZONE_PLATFORM_HINT = "wayland"; # fixes electron wayland
        };

        input = {
          keyboard = {
            repeat-delay = 275;
            repeat-rate = 70;
          };
        };

        outputs = {
          "HDMI-A-1" = {
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
          "DP-1" = {
            enable = true;
            mode = {
              width = 2560;
              height = 1440;
            };
            position = {
              x = 1200;
              y = 480;
            };
            variable-refresh-rate = false;
          };
          ## RIGHT MONITOR
          "DP-2" = {
            enable = true;
            mode = {
              width = 1920;
              height = 1080;
            };
            position = {
              x = 3760;
              y = 580;
            };
            #transform.rotation = 90;
          };
        };

        layout = {
          preset-column-widths = [
            { proportion = 2. / 5.; }
            { proportion = 2.45 / 5.; }
            { proportion = 3.5 / 5.; }
            { proportion = 4. / 5.; }
          ];

          preset-window-heights = [
            { proportion = 1. / 4.; }
            { proportion = 1. / 2.; }
            { proportion = 3. / 4.; }
            { proportion = 1. / 1.; }
          ];
        };

        workspaces = {
        };

        spawn-at-startup = [
          ## BAR
          { command = [ "waybar" ]; }
          ## BLUETOOOTH
          { command = [ "blueman-applet" ]; }
          ## TAILSCALE TRAY
          {
            command = [
              "trayscale"
              "--hide-window"
            ];
          }
          { ## CLIPBOARD
            command = [
              "copyq"
              "--start-server"
            ];
          }
          { ## GAMMA
            command = [
              "gammastep-indicator"
              "-l"
              "38.0628:-91.4035"
              "-t"
              "6500:4800"
            ];
          }
          ## GDRIVE
          {
            command = [
              "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse"
              "/home/neko/Documents/GoogleDrive/"
            ];
          }
          { ## KDE-CONNECT
            command = [ "${pkgs.kdePackages.kdeconnect-kde}/libexec/kdeconnect" ];
          }
          {
            command = [ "kdeconnect-indicator" ];
          }
          { ## POWER SAVINGS
            command = [
              "sh"
              "-c"
              "swayidle -w timeout 1201 'niri msg action power-off-monitors' timeout 1200 'swaylock-fancy -f' before-sleep 'swaylock-fancy -f'"
            ];
          }
          ## WALLPAPER
          {
            command = [
              "swaybg"
              "-i"
              "/home/neko/Pictures/Wallpapers/4K/Weather/Wallpaper forest, trees, snow, winter, 4k, Nature 8421417542.jpg"
            ];
          }
          ## XWAYLAND
          {
            command = [
              "xrandr"
              "--output"
              "DP-1"
              "--primary"
            ];
          }
        ];

        binds =
          with config.lib.niri.actions;
          let
            sh = spawn "sh" "-c";
            Mod = "Mod";
            #if options.virtualization ? qemu
            #then "Alt"
            #else "Mod";
            suffixes = builtins.listToAttrs (
              map (n: {
                name = toString n;
                value = [
                  "workspace"
                  n
                ];
              }) (range 1 9)
            );
          in
          {

            /**
              ******
              * BASIC *
              *******
            */
            ## QUIT NIRI/TURN OFF MONITORS
            "${Mod}+Shift+Escape".action = quit;
            "${Mod}+Shift+P".action = power-off-monitors;
            "${Mod}+Shift+Backslash".action = show-hotkey-overlay;
            "${Mod}+Shift+Grave".action = toggle-overview;
            # Replace this with swaylock-effects "${Mod}+L".action.spawn = "blurred-locker";
            ## CLOSE WINDOW
            "${Mod}+Q".action.close-window = [ ];
            ## TERMINAL/LAUNCHER
            "${Mod}+D".action.spawn = "fuzzel";
            ## NEWELLE
            "Alt+BackSpace".action = sh ( builtins.concatStringsSep "; " [
              "flatpak run --command=gsettings moe.nyarchlinux.assistant set moe.nyarchlinux.assistant startup-mode 'mini'"
              "flatpak run moe.nyarchlinux.assistant"
            ]);

            "${Mod}+BackSpace".action.spawn = "kitty";
            ## RESTART WAYBAR/SWAYBAR
            "${Mod}+W".action = sh (
              builtins.concatStringsSep "; " [
                "systemctl --user restart waybar.service"
                "systemctl --user restart swaybg.service"
              ]
            );

            #-----------#
            # CLIPBOARD #
            #-----------#
            "${Mod}+Control+V".action.spawn = [
              "copyq"
              "toggle"
            ];

            #------------#
            # SCREENSHOT #
            #------------#
            "${Mod}+Shift+S".action.spawn = [
              "niri"
              "msg"
              "action"
              "screenshot"
            ];
            "${Mod}+Print".action.spawn = [
              "niri"
              "msg"
              "action"
              "screenshot-window"
            ];

            #-----------------#
            # VOLUME CONTROLS #
            #-----------------#
            "XF86AudioRaiseVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
            "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
            "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "XF86AudioNext" = {
              action = focus-column-right;
              hotkey-overlay.hidden = true;
            };
            "XF86AudioPrev" = {
              action = focus-column-left;
              hotkey-overlay.hidden = true;
            };

            #-------------------#
            # WINDOW MANAGEMENT #
            #-------------------#
            ## CONSUME/EXPEL
            "${Mod}+C".action.consume-window-into-column = [ ];
            "${Mod}+X".action.expel-window-from-column = [ ];
            ## TABBED COLUMN DISPLAY?
            "${Mod}+G".action.toggle-column-tabbed-display = [ ];
            ## TOGGLE FLOATING/SWITCH FOCUS BETWEEN TILED AND FLOATING
            "${Mod}+S".action = toggle-window-floating;
            "${Mod}+Tab".action = switch-focus-between-floating-and-tiling;
            ## SCRATCHPAD
            "${Mod}+Grave".action.spawn = [
              "kitty"
              "--class"
              "kitty_dropdown"
              "kitten"
              "quick-access-terminal"
            ];
            ## RESIZE WINDOWS (WIDTH RESIZES COLUMNS)
            ## CYCLE WINDOW SIZE
            "${Mod}+B".action = switch-preset-column-width;
            "${Mod}+Shift+B".action = switch-preset-window-width;
            "${Mod}+V".action = switch-preset-window-height;

            ## MANUAL RESIZE
            "${Mod}+Ctrl+H".action = set-window-width "-1%";
            "${Mod}+Ctrl+N".action = set-window-height "+1%";
            "${Mod}+Ctrl+E".action = set-window-height "-1%";
            "${Mod}+Ctrl+I".action = set-window-width "+1%";

            ## FULLSCREEN
            "${Mod}+F".action = maximize-column;
            "${Mod}+Shift+F".action = fullscreen-window;

            ## COLUMN SCREEN ALIGNMENT
            #"${Mod}+Ctrl+Shift+C".action = center-column;
            #"${Mod}+Ctrl+Shift+Z".action = center-column;

            #-------#
            # FOCUS #
            #-------#

            ## FOCUS WITH VI KEYS (COLEMAK)
            "${Mod}+H".action = focus-column-left;
            "${Mod}+N".action = focus-window-or-workspace-down;
            "${Mod}+E".action = focus-window-or-workspace-up;
            "${Mod}+I".action = focus-column-right;
            ## FOCUS COLUMN
            "${Mod}+Comma".action = focus-monitor-left;
            "${Mod}+Period".action = focus-monitor-right;
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

            /**
              *******************
              * MOVE WINDOW/COLUMN *
              ********************
            */
            ## MOVE COLUMN/WINDOW WITH VI KEYS
            "${Mod}+Shift+H".action = move-column-left;
            "${Mod}+Shift+N".action = move-window-down-or-to-workspace-down;
            "${Mod}+Shift+E".action = move-window-up-or-to-workspace-up;
            "${Mod}+Shift+I".action = move-column-right;
            "${Mod}+Shift+Comma".action = move-column-to-monitor-left;
            "${Mod}+Shift+Period".action = move-column-to-monitor-right;
            ## MOVE WINDOW TO MONITOR WITH ARROW KEYS
            "${Mod}+Control+Left".action = move-window-to-monitor-left;
            "${Mod}+Control+Down".action = move-window-to-monitor-down;
            "${Mod}+Control+Up".action = move-window-to-monitor-up;
            "${Mod}+Control+Right".action = move-window-to-monitor-right;
            ## MOVE WINDOW TO WORKSPACE
            #  "${Mod}+Shift+1".action = move-column-to-workspace 1;
            #  "${Mod}+Shift+2".action = move-column-to-workspace 2;
            #  "${Mod}+Shift+3".action = move-column-to-workspace 3;
            #  "${Mod}+Shift+4".action = move-column-to-workspace 4;
            #  "${Mod}+Shift+5".action = move-column-to-workspace 5;
          };

        window-rules =
          let
            colors = config.lib.stylix.colors.withHashtag;
          in
          [
            ## ROUNDED CORNERS
            {
              draw-border-with-background = false;
              geometry-corner-radius =
                let
                  r = 8.0;
                in
                {
                  top-left = r;
                  top-right = r;
                  bottom-left = r;
                  bottom-right = r;
                };
              clip-to-geometry = true;
            }
            ## DRAW UNFOCUSED WITH OPACITY (BROKEN ON NVIDIA 570, flickers)
            {
              matches = [
                {
                  is-focused = false;
                }
              ];
              opacity = 0.95;
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
            ## FLOAT ZEN PIP
            {
              matches = [
                {
                  app-id = "^zen-twilight$";
                  title = "^Picture-in-Picture$";
                }
              ];
              opacity = 0.9;
              open-floating = true;
              open-focused = false;
              default-column-width.fixed = 425;
              default-window-height.fixed = 250;
              default-floating-position = {
                relative-to = "top-right";
                x = 75;
                y = 50;
              };
            }
            ## FLOAT FF PIP
            {
              matches = [
                {
                  app-id = "^firefox-aurora$";
                  title = "^Picture-in-Picture$";
                }
              ];
              opacity = 0.9;
              open-floating = true;
              open-focused = false;
              default-column-width.fixed = 425;
              default-window-height.fixed = 250;
              default-floating-position = {
                relative-to = "top-right";
                x = 75;
                y = 50;
              };
            }
            ## COPYQ CLIPBOARD MANAGER
            {
              matches = [
                {
                  app-id = "^com.github.hluk.copyq$";
                }
              ];
              open-floating = true;
            }
            ## CLIPSE CLIPBOARD MANAGER
            {
              matches = [
                {
                  title = "^clipse.*";
                  app-id = "^kitty$";
                }
              ];
              open-floating = true;
            }
            ## SUSHI - GNOME FILES PREVIEW
            {
              matches = [
                {
                  app-id = "^org.gnome.NautiliusPreviewer";
                }
              ];
              open-floating = true;
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
            ## THIS PREVENTS NIRI WM HELP MENU FROM BEING TRANSPARENT I THINK
            {
              matches = [ { app-id = "^niri$"; } ];
              opacity = 1.0;
            }
          ];
      };
    };

    waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          position = "left";
          output = [
            "${_g.monitors.center.output}"
            "${_g.monitors.right.output}"
          ];
          include = [ "~/.config/waybar/default_modules.json" ];
          height = 1000;
          width = 10;
          spacing = 0;
          align = 0;
          modules-left = [
            "niri/workspaces"
            "hyprland/workspaces"
          ];
          modules-center = [
          ];
          modules-right = [
            "idle_inhibitor"
            "tray"
            "pulseaudio"
            "cpu"
            "memory"
            "temperature"
            "clock"
          ];
        }
        {
          layer = "top";
          position = "top";
          output = [
            "${_g.monitors.left.output}"
          ];
          include = [
            "~/.config/waybar/default_modules.json"
          ];
          height = 30;
          spacing = 4;
          modules-left = [
            "niri/workspaces"
            "hyprland/workspaces"
          ];
          modules-center = [ ];
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
          padding: 0 0px;
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
          text-shadow: inherit;
        }
        #workspaces button:hover {
          background: #1a1a1a;
          border: #1a1a1a;
          padding: 0 0px;
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
        #pulseaudio {
          margin-left: 4px;
        }
        #memory {
          margin-right: 3px;
        }
        #cpu {
          margin-right: 3px;
        }
        #battery,
        #disk {
          padding: 0 10px;
        }
      '';
      systemd.enable = false;
    };
  };
}
