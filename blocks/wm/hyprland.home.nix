{
  config,
  lib,
  pkgs,
  ...
}:
let
  _g = import ../../lib/globals.nix { inherit config; };
  useHyprscrolling = true;
in
{

  imports = [
    ./waybar.home.nix
  ];

  home.packages = with pkgs; [
    copyq
    hdrop
    hyprpaper
    hyprshot
    rofi
    hypridle
    hyprlock
    swaynotificationcenter
    wayland-utils
    waypaper
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      enable = true;
    };

    settings = {
      #-------- Hyprland Variables --------#
      general = {
        # https://wiki.hyprland.org/Configuring/Variables/ for more
        allow_tearing = true;
        gaps_in = 5;
        gaps_out = 10;
        border_size = 4;
        layout = if useHyprscrolling then "scrolling" else "dwindle";

        "col.active_border" = "rgba(99c0d0ff) rgba(5e81acff) 45deg";
        "col.inactive_border" = "rgba(2e3440ff)";
        "col.nogroup_border" = "rgba(60728aff)";
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 2, myBezier"
          "windowsOut, 1, 2, default, popin 80%"
          "border, 1, 2, default"
          "borderangle, 1, 2, default"
          "fade, 1, 2, default"
          "workspaces, 1, 2, default"
        ];
      };

      cursor = {
        no_hardware_cursors = false;
      };

      dwindle = {
        force_split = 2;
        preserve_split = true;
      };

      scrolling = {
        focus_fit_method = 0;
      };

      debug = {
        disable_logs = false;
      };

      decoration = {
        rounding = 7;
      };

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
        "XCURSOR_THEME,volantes-cursors"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,volantes-light-hyprcursor"
        "HYPRCURSOR_SIZE,24"
      ];

      experimental = {
      };

      input = {
        kb_layout = "us";
        repeat_rate = 80;
        repeat_delay = 280;
        follow_mouse = 2;
        mouse_refocus = false;
        float_switch_override_focus = 0;
        numlock_by_default = true;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      misc = {
        vfr = true;
      };
      #-------- Startup --------#
      exec-once = [
        "waypaper --restore"
        "swaync"
        # ## Idleing stuff
        #"swayidle -w timeout 600 'if pgrep -x swaylock; then hyprctl dispatch dpms off; fi' resume 'hyprctl dispatch dpms on'"
        #"swayidle -w timeout 900 'swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2' timeout 930 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"
        ## Clipboard Shenanigans
        "copyq --start-server"
        ## KDE Connect
        "${pkgs.kdePackages.kdeconnect-kde}/libexec/kdeconnect"
        "kdeconnect-indicator"
        "blueman-applet" # Bluetooth
        "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse ~/GoogleDrive" # Google Drive
        "xrandr --output DP-1 --primary" # set Primary Monitor for Xwayland
        #"gammastep-indicator -l 38.0628:-91.4035 -t 6500:4800" # (Night/Red/Blue)shift for wayland
      ];

      #-------- Window Rules --------#
      #
      windowrules = [
        ## Clipboard
        "float, match:class ^clipse$"
        "size 622 652, match:class ^clipse$"

        ## File Pickers
        "float, match:class xdg-desktop-portal(.*)"
        "size 1060 960, match:title (.*)(Select a)(.*)"
        "center, match:title (.*)(Select a)(.*)"

        ## FIREFOX Picture-in-Picture
        "float, match:class ^firefox-devedition$, match:title (.*)(Picture-in-Picture)(.*)"
        "size 615 346, match:class ^firefox-devedition$, match:title (.*)(Picture-in-Picture)(.*)"
        "move 1920 56, match:class ^firefox-devedition$, match:title (.*)(Picture-in-Picture)(.*)"
        "no_initial_focus, match:class ^firefox-devedition$, match:title (.*)(Picture-in-Picture)(.*)"

        ## FIREFOX-NIGHTLY Picture-in-Picture
        "float, match:class ^firefox-nightly$, match:title (.*)(Picture-in-Picture)(.*)"
        "size 615 346, match:class ^firefox-nightly$, match:title (.*)(Picture-in-Picture)(.*)"
        "move 1920 56, match:class ^firefox-nightly$, match:title (.*)(Picture-in-Picture)(.*)"
        "no_initial_focus, match:class ^firefox-nightly$, match:title (.*)(Picture-in-Picture)(.*)"

        ## Pin Entry (GPG)
        "float, match:class Pinentry(.*)"
        "center, match:class Pinentry(.*)"

        ## Steam
        "immediate, match:class ^steam_app_(.*)"
        "workspace 7 silent, match:class ^steam_app_(.*)"
        "float, match:class ^steam_app_(.*)"

        ## qBittorrent
        "workspace 9 silent, match:class ^org\.qbittorrent\.qBittorrent$"

        ## Chatterino / Streamlink-Twitch-GUI
        "workspace 10 silent, match:class ^streamlink-twitch-gui$"
        "workspace 10 silent, match:class ^chatterino$"

        ## Copyq Clipboard Manager
        "float, match:class ^com\.github\.hluk\.copyq$"

        ## Discord (Vencord)
        "workspace 10 silent, match:class ^vencorddesktop$"

        ## MPV Picture-in-Picture
        "workspace 10, match:class ^mpv_pip$"
        "float, match:class ^mpv_pip$"
        "size 659 369, match:class ^mpv_pip$"
        "move 416 33, match:class ^mpv_pip$"
        "pin, match:class ^mpv_pip$"
      ];

      #-------- Key Bindings --------#
      "$mainMod" = "SUPER";
      bind = [
        # Misc Binds (kitty, close window, quit session, rofi, etc)
        "$mainMod, BACKSPACE, exec, kitty"
        "$mainMod, Q, killactive, "
        "$mainMod ALT, ESCAPE, exit, "
        "$mainMod CONTROL, F, exec, nautilus"

        "$mainMod ALT, L, exec, ~/hypr/swayidle-swaylock-hypr.sh"

        # Whisper STT
        "$mainMod CONTROL ALT SHIFT, D, exec, ~/.local/state/nix/profiles/imperative/bin/xhisper"

        "$mainMod, S, togglefloating,"

        "$mainMod, F, fullscreen"
        "$mainMod CONTROL, F, exec, nautilus"
        "$mainMod, GRAVE, exec, hdrop -f -b -g 30 kitty --class kittydrop"

        # (not)Rofi
        "$mainMod, D, exec, rofi -show combi -combi-modes window,drun,ssh,run,filebrowser,recursivebrowser"
        "$mainMod CONTROL, V, exec, copyq show"

        # Groups and Movement in / out of them
        "$mainMod, G, togglegroup"
        "$mainMod, tab, changegroupactive"
        "$mainMod ALT, left, moveintogroup, l"
        "$mainMod ALT, right, moveintogroup, r"
        "$mainMod ALT, up, moveintogroup, u"
        "$mainMod ALT, down, moveintogroup, d"
        "$mainMod, M, moveoutofgroup"

        # Cycle focus between floating windows
        "$mainMod, Tab, cyclenext"
        "$mainMod, Tab, bringactivetotop"

        # Presel split
        "$mainMod CONTROL SHIFT, E, layoutmsg, preselect u"
        "$mainMod CONTROL SHIFT, N, layoutmsg, preselect d"
        "$mainMod CONTROL SHIFT, H, layoutmsg, preselect l"
        "$mainMod CONTROL SHIFT, I, layoutmsg, preselect r"

        # Switch Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move Active Window to Workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll Through Workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Screenshot / Capture
        "SHIFT, PRINT, exec, hyprshot -m window" # Screenshot a window
        ", PRINT, exec, hyprshot -m output" # Screenshot a monitor
        "CONTROL, PRINT, exec, hyprshot -m region" # Screenshot a region

        # Volume
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ]
      ++ lib.optionals (!useHyprscrolling) [
        # Cycle Workspaces on Monitor
        "$mainMod, comma, workspace, m-1"
        "$mainMod, period, workspace, m+1"

        # Move Focus
        "$mainMod, H, movefocus, l"
        "$mainMod, N, movefocus, d"
        "$mainMod, E, movefocus, u"
        "$mainMod, I, movefocus, r"

        # Dwindle Specific
        "$mainMod, P, pseudo" # dwindle
        "$mainMod, J, togglesplit" # dwindle
      ]
      ++ lib.optionals useHyprscrolling [
        "$mainMod, minus, layoutmsg, colresize -conf"
        "$mainMod, equal, layoutmsg, colresize +conf"

        # Focus
        "$mainMod, H, layoutmsg, move -col"
        "$mainMod, N, movefocus, d"
        "$mainMod, E, movefocus, u"
        "$mainMod, I, layoutmsg, move +col"
        "$mainMod, period, focusmonitor, r"
        "$mainMod, comma, focusmonitor, l"

        # Expel
        "$mainMod, X, layoutmsg, promote"
      ];

      binde = [
        "$mainMod SHIFT, left, moveactive, -10 0"
        "$mainMod SHIFT, down, moveactive, 0 10"
        "$mainMod SHIFT, up, moveactive, 0 -10"
        "$mainMod SHIFT, right, moveactive, 10 0"

        ## works in both scrolling / dwindle layouts
        "$mainMod SHIFT, H, exec, ~/.config/hypr/move-windows.sh l"
        "$mainMod SHIFT, N, exec, ~/.config/hypr/move-windows.sh d"
        "$mainMod SHIFT, E, exec, ~/.config/hypr/move-windows.sh u"
        "$mainMod SHIFT, I, exec, ~/.config/hypr/move-windows.sh r"

        ## sets repeatable binds for resizing the active window
        "$mainMod CONTROL, H, resizeactive, -30 0"
        "$mainMod CONTROL, N, resizeactive, 0 30"
        "$mainMod CONTROL, E, resizeactive, 0 -30"
        "$mainMod CONTROL, I, resizeactive, 30 0"

        "$mainMod CONTROL, left, resizeactive, -10 0"
        "$mainMod CONTROL, right, resizeactive, 10 0"
        "$mainMod CONTROL, up, resizeactive, 0 -10"
        "$mainMod CONTROL, down, resizeactive, 0 10"
      ]
      ++ lib.optionals (!useHyprscrolling) [
      ]
      ++ lib.optionals useHyprscrolling [
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      monitor = [
        "${_g.monitors.left.output}, ${_g.monitors.left.res.width}x${_g.monitors.left.res.height}, ${_g.monitors.left.pos.x}x${_g.monitors.left.pos.y}, 1, transform, 3"
        "${_g.monitors.center.output}, ${_g.monitors.center.res.width}x${_g.monitors.center.res.height}@${_g.monitors.center.rate}, ${_g.monitors.center.pos.x}x${_g.monitors.center.pos.y}, 1"
        "${_g.monitors.right.output}, ${_g.monitors.right.res.width}x${_g.monitors.right.res.height}, ${_g.monitors.right.pos.x}x${_g.monitors.right.pos.y}, 1, transform, 1"
      ];

      workspace = [
        "8, monitor:${_g.monitors.left.output}, default:true"
        "1, monitor:${_g.monitors.center.output}, default:true"
        "7, monitor:${_g.monitors.center.output}"
        "10, monitor:${_g.monitors.right.output}, default:true"
      ];

    };
  };
}
