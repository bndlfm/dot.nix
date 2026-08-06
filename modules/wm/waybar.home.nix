{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.nerd-fonts.terminess-ttf
    pkgs.nerd-fonts.symbols-only
  ];
  fonts.fontconfig.enable = true;
  programs.waybar = {
    enable = true;
    settings =
      let
        _g = import ../../lib/globals.nix { inherit config; };
        default_modules = builtins.fromJSON /* json */ ''
          {
            "wlr/workspaces": {
              "disable-scroll": false,
              "all-outputs": false,
              "format": "{name}: {icon}",
              "format-icons": {
                "1": " ",
                "2": " ",
                "3": " ",
                "4": "󰎞 ",
                "5": " ",
                "6": " ",
                "7": " ",
                "8": " ",
                "9": "󰠳 ",
                "10": " ",
                "urgent": " ",
                "focused": " ",
                "default": " "
              }
            },
            "hyprland/workspaces": {
              "disable-scroll": false,
              "all-outputs": false,
              "format": "{name}: {icon}",
              "format-icons": {
                "1": " ",
                "2": " ",
                "3": " ",
                "4": "󰎞 ",
                "5": " ",
                "6": " ",
                "7": " ",
                "8": " ",
                "9": "󰠳 ",
                "10": " ",
                "urgent": " ",
                "focused": " ",
                "default": " "
              }
            },
            "keyboard-state": {
              "numlock": true,
              "capslock": false,
              "format": "{name} {icon}",
              "format-icons": {
                "locked": " ",
                "unlocked": " "
              }
            },
            "wlr/mode": {
              "format": "<span style=\"italic\">{}</span>"
            },
            "wlr/scratchpad": {
              "format": "{icon} {count}",
              "show-empty": true,
              "format-icons": [
                "",
                ""
              ],
              "tooltip": true,
              "tooltip-format": "{app}: {title}"
            },
            "mpd": {
              "format": "{stateIcon}  {consumeIcon}{singleIcon}{artist} - {title}",
              "format-disconnected": "Disconnected ",
              "format-stopped": "{consumeIcon}Stopped",
              "unknown-tag": "N/A",
              "interval": 2,
              "consume-icons": {
                "on": " "
              },
              "random-icons": {
                "off": "<span color=\"#f53c3c\"></span> ",
                "on": " "
              },
              "repeat-icons": {
                "on": " "
              },
              "single-icons": {
                "on": "1 "
              },
              "state-icons": {
                "paused": "",
                "playing": ""
              },
              "tooltip-format": "MPD (connected)",
              "tooltip-format-disconnected": "MPD (disconnected)"
            },
            "idle_inhibitor": {
              "format": "{icon}",
              "format-icons": {
                "activated": " ",
                "deactivated": " "
              }
            },
            "tray": {
              "spacing": 2
            },
            "clock": {
              "format": "<b>{:%H:%M}</b> ",
              "tooltip-format": "\n<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
              "format-alt": "{:%Y-%m-%d}"
            },
            "cpu": {
              "format": "{usage}   ",
              "tooltip": true
            },
            "memory": {
              "format": "{}  "
            },
            "temperature": {
              "critical-threshold": 80,
              "format": "{temperatureC}{icon}",
              "format-icons": [
                "",
                "",
                ""
              ]
            },
            "network": {
              "format-wifi": "{essid} ({signalStrength}%) ",
              "format-ethernet": "{ipaddr}/{cidr} ",
              "tooltip-format": "{ifname} via {gwaddr} ",
              "format-linked": "{ifname} (No IP) ",
              "format-disconnected": "Disconnected ⚠",
              "format-alt": "{ifname}: {ipaddr}/{cidr}"
            },
            "pulseaudio": {
              "scroll-step": 3,
              "format": "{volume}{icon} \n{format_source}",
              "format-bluetooth": "{volume}{icon} \n{format_source}",
              "format-bluetooth-muted": "{icon} \n{format_source}",
              "format-muted": "󰋎 {format_source}",
              "format-source": "",
              "format-source-muted": " ",
              "format-icons": {
                "headphone": " ",
                "hands-free": " ",
                "headset": " ",
                "phone": " ",
                "portable": " ",
                "car": " ",
                "default": [
                  " ",
                  " ",
                  " "
                ]
              },
              "on-click": "pavucontrol"
            },
            "wireplumber": {
              "format": "{volume}% {icon}  ",
              "format-muted": "Muted {icon}  ",
              "format-icons": {
                  "default": ["", "", ""]
              },
              "tooltip": true,
              "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
              "on-scroll-up": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
              "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
              "scroll-step": 5
            },
            "custom/wl-gammarelay-temperature": {
                "format": "{} ",
                "exec": "wl-gammarelay-rs watch {t}",
                "on-scroll-up": "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100",
                "on-scroll-down": "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100"
            },
            "custom/wl-gammarelay-brightness": {
                "format": "{}% ",
                "exec": "wl-gammarelay-rs watch {bp}",
                "on-scroll-up": "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateBrightness d +0.02",
                "on-scroll-down": "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateBrightness d -0.02"
            },
            "custom/wl-gammarelay-gamma": {
                "format": "{}% γ",
                "exec": "wl-gammarelay-rs watch {g}",
                "on-scroll-up": "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateGamma d +0.02",
                "on-scroll-down": "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateGamma d -0.02"
            }
          }
        '';
      in
      [
        (
          default_modules
          // {
            layer = "top";
            position = "top";
            output = [
              "${_g.monitors.left.output}"
              "${_g.monitors.center.output}"
              "${_g.monitors.right.output}"
            ];
            margin-top = 4;
            margin-left = 12;
            margin-right = 12;
            spacing = 6;
            align = 0;
            modules-left = [
              "niri/workspaces"
              "hyprland/workspaces"
            ];
            modules-center = [
              "tray"
            ];
            modules-right = [
              "idle_inhibitor"
              "wireplumber"
              "cpu"
              "memory"
              "temperature"
              "clock"
            ];
          }
        )
        (
          default_modules
          // {
            layer = "top";
            position = "top";
            output = [
            ];
            margin-top = 4;
            margin-left = 12;
            margin-right = 12;
            spacing = 6;
            modules-left = [
              "niri/workspaces"
              "hyprland/workspaces"
            ];
            modules-center = [ ];
            modules-right = [
              "clock"
            ];
          }
        )
      ];
    style = /* css */ ''
      @define-color bg #2e3440;
      @define-color bg-alt #3b4252;
      @define-color bg-hover #4c566a;
      @define-color fg #eceff4;
      @define-color fg-alt #d8dee9;
      @define-color accent #88c0d0;
      @define-color red #bf616a;
      @define-color green #a3be8c;
      @define-color yellow #ebcb8b;
      @define-color blue #81a1c1;
      @define-color purple #b48ead;

      * {
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        font-family: "Symbols Nerd Font", "Terminess Nerd Font", monospace;
        font-size: 18px;
        background-color: transparent;
        color: @fg;
      }

      tooltip {
        background: @bg;
        border: 2px solid @bg-alt;
        border-radius: 12px;
      }

      tooltip label {
        color: @fg;
      }

      #clock,
      #pulseaudio,
      #wireplumber,
      #memory,
      #cpu,
      #temperature,
      #battery,
      #disk,
      #tray,
      #idle_inhibitor {
        background-color: @bg;
        color: @fg-alt;
        border-radius: 16px;
        padding: 0px 14px;
        box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.4);
      }

      #workspaces {
        background-color: @bg;
        border-radius: 16px;
        padding: 0;
        box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.4);
      }

      #workspaces button {
        padding: 0px 8px;
        color: @fg-alt;
        border-radius: 16px;
        transition: all 0.2s ease;
      }

      #workspaces button:hover {
        background-color: @bg-hover;
        box-shadow: inherit;
        text-shadow: inherit;
      }

      #workspaces button.active {
        color: @bg;
        background-color: @accent;
        font-weight: bold;
      }

      #workspaces button.visible:not(.active) {
        color: @fg;
        background-color: @bg-alt;
      }

      #clock {
        color: @fg;
        font-weight: bold;
        background-color: @bg-alt;
      }

      #pulseaudio, #wireplumber {
        color: @blue;
      }

      #memory {
        color: @purple;
      }

      #cpu {
        color: @green;
      }

      #temperature {
        color: @yellow;
      }

      #temperature.critical {
        background-color: @red;
        color: @bg;
      }

      #tray {
        padding: 0px 8px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      #idle_inhibitor {
        color: @fg-alt;
      }

      #idle_inhibitor.activated {
        color: @accent;
      }
    '';
    systemd = {
      enable = false;
      targets = [ "graphical-session.target" ];
    };
  };
}
