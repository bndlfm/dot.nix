{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.nerd-fonts.terminess-ttf
  ];
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
            height = 38;
            spacing = 5;
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
            height = 38;
            spacing = 5;
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
      window#waybar {
        font-size: 16px;
        font-family: CaskaydiaMono Nerd Font Mono;
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
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };
}
