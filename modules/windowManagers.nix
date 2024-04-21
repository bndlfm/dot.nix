{ pkgs, ... }:
{
  ########## XSESSION - BSPWM ##########
  xsession.windowManager.bspwm = {
    enable = true;
    alwaysResetDesktops = true;
    monitors = { HDMI-0 = [ "1" "2" "3" ]; DP-4 = [ "4" "5" "6" "7" "8" "9" ];};
    settings = {
      border_width = 6;
      window_gap = 12;
      split_ratio = 0.52;
      borderless_monocle = true;
      gapless_monocle = true;
    };
    rules = {
      "steam" = { floating = true; };
      "steam_app" = { floating = true; };
      "Steam" = { floating = true; };
      "mpv" = { floating = true; };
      "synergy" = { floating = true; };
      "blueman-applet" = { floating = true; };
    };
    startupPrograms = [
      "sxhkd"
      "~/.config/polybar/polybar.sh"
      "dunst"
      "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse ~/Documents/GoogleDrive"
      "xset r rate 325 70"
      "xset m 0 0"
      "nitrogen --restore"
      "xsetroot -xcf ${pkgs.volantes-cursors}/share/icons/volantes_light_cursors/cursors/left_ptr 32"
      "${pkgs.kdeconnect}/libexec/kdeconnectd"
      "kdeconnect-indicator"
    ];
  };
  home.packages = with pkgs; [
    (writeShellScriptBin "scrotshot.sh" /* sh */ ''
      #!/bin/bash

      # Function to capture screenshot and copy to clipboard
      capture_screenshot() {
        scrot "$@" --exec 'xclip -selection clipboard -t image/png -i < $f && notify-send "Screenshot Captured"'
      }

      # Check the command-line argument and execute the corresponding scrot command
      case "$1" in
        "full")
            capture_screenshot ~/%b%d::%H%M%S.png --multidisp --quality 75
            ;;
        "freeze")
            capture_screenshot ~/%b%d::%H%M%S.png --freeze --quality 75
            ;;
        "select")
            capture_screenshot --select --freeze --quality 75 ~/%b%d::%H%M%S.png
            ;;
        "focused")
            capture_screenshot ~/%b%d::%H%M%S.png --focused --border --delay 5 --count --quality 75
            ;;
        *)
            echo "Usage: $0 [full|freeze|select|focused]"
            exit 1
            ;;
      esac
    '')
  ];


  ######### (HM) WAYLAND HYPRLAND ########
  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      enable = true;
    };

    #plugins = with pkgs; [];
    #
    settings = {
      "$mainMod" = "SUPER";

      monitor = [
        "HDMI-A-1, 1920x1080, 322x0, 1"
        "DP-1, disable"
        "DP-3, 2560x1440@144, 0x1080, 1, bitdepth, 10"
      ];

      workspace = [
        "10, monitor:HDMI-A-1, default:true"
        "1, monitor:DP-3, default:true"
        "7, monitor:DP-3"
      ];

      misc = {
        vrr=1;
        vfr=true;
        };

      #-------- Hyprland Variables --------#
      general = {
        # https://wiki.hyprland.org/Configuring/Variables/ for more
        allow_tearing = true;
        gaps_in = 5;
        gaps_out = 10;
        border_size = 4;
        #layout = slidr;
        layout = "dwindle";
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

      decoration = {
        rounding = 7;
        #"blur"= true;
        #"blur_size" = 3;
        #"blur_passes" = 2;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        #"col.shadow" = "rgba(1a1a1aee)";
        #"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        #"col.shadow_inactive_border" = "rgba(595959aa)";
      };

      env = [
        "GBM_BACKEND,nvidia-drm"
        "GDK_BACKEND,wayland"
        "__GL_GSYNC_ALLOWED,1"
        "__GL_VRR_ALLOWED,1"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "LIBVA_DRIVER_NAME,nvidia"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland"
        "VRR,1"
        "vrr,1"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_DRM_NO_ATOMIC,1"
        "XCURSOR_SIZE,24"
        "XDG_SESSION_DESKTOP,hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,hyprland"
      ];

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

      #-------- Window Rules --------#
      windowrule = [
        ## Chatterino/Streamlink-Twitch-GUI
          "workspace 10 silent, streamlink-twitch-gui"
          "workspace 10 silent, chatterino"
        ## Discord
          "workspace 10 silent, vencorddesktop"
        ## MPV Picture-in-Picture
          "workspace 10, mpv_pip"
          "float, mpv_pip"
          "size 659 369, mpv_pip"
          "move 416 33, mpv_pip"
          "pin, mpv_pip"
        ## Steam
          "workspace 7 silent, steam"
          "float, steam"
        ];
      windowrulev2 = [
        ## File Pickers
          "float, class:xdg-desktop-portal(.*)"
          "size 1060 960, title:(.*)(Select a)(.*)"
          "center, title:(.*)(Select a)(.*)"
        ## Pin Entry (GPG)
          "float, class:Pinentry(.*)"
          "center, class:Pinentry(.*)"
        ## Steam
          "immediate, class:^(steam_app_(.*))"
        ## qBittorrent
          "workspace 9 silent, class:org.qbittorrent.qBittorrent"
      ];

      "exec-once" = [
        "waybar"
        "ibus-daemon"
        "blueman-applet"
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all"
        "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse ~/GoogleDrive"
        "gammastep-indicator -l 38.0628:-91.4035 -t 6500:4800"
        "${pkgs.kdeconnect}/libexec/kdeconnectd"
        "kdeconnect-indicator"
        "swayidle -w timeout 600 'if pgrep -x swaylock; then hyprctl dispatch dpms off; fi' resume 'hyprctl dispatch dpms on'"
        "swayidle -w timeout 900 'swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2' timeout 930 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"
        "swaybg"
        "xrandr --output DP-3 --primary"
        "ydotoold"
        "export $(dbus-launch)"
        "systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE"
        ];
      bind = [
        # Misc Binds (kitty, close window, quit session, rofi, etc)
        "$mainMod, BACKSPACE, exec, kitty"
        "$mainMod, Q, killactive, "
        "$mainMod ALT, ESCAPE, exit, "
        "$mainMod CONTROL, F, exec, dolphin"

        "$mainMod ALT, L, exec, ~/hypr/swayidle-swaylock-hypr.sh"

        "$mainMod, S, togglefloating,"

        "$mainMod, F, fullscreen"
        "$mainMod, P, pseudo" # dwindle
        "$mainMod, J, togglesplit" # dwindle

        # Rofi
        "$mainMod, SPACE, exec, rofi -show combi -combi-modi window,drun,run,ssh,combi -show-icons -monitor -1"
        "$mainMod SHIFT, C, exec, rofi -show calc"
        "$mainMod SHIFT, V, exec, rofi -modi 'clipboard:greenclip print' -show clipboard -run '{cmd}' -show-icons"
        "$mainMod, K, exec, /usr/bin/splatmoji copy"
        "$mainMod ALT, C, exec, pkill greenclip && greenclip clear && greenclip daemon"

        # Groups and Movement in / out of them
        "$mainMod, G, togglegroup"
        "$mainMod, C, changegroupactive"
        "$mainMod ALT, left, moveintogroup, l"
        "$mainMod ALT, right, moveintogroup, r"
        "$mainMod ALT, up, moveintogroup, u"
        "$mainMod ALT, down, moveintogroup, d"
        "$mainMod, R, moveoutofgroup"

        # Move Focus
        "$mainMod, H, movefocus, l"
        "$mainMod, N, movefocus, d"
        "$mainMod, E, movefocus, u"
        "$mainMod, I, movefocus, r"

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

        # Cycle Workspaces on Monitor
        "$mainMod, comma, workspace, m-1"
        "$mainMod, period, workspace, m+1"

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

        # Screenshot a window
        "SHIFT, PRINT, exec, hyprshot -m window"
        # Screenshot a monitor
        ", PRINT, exec, hyprshot -m output"
        # Screenshot a region
        "CONTROL, PRINT, exec, hyprshot -m region"

        # Volume
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];
      binde = [
        # Move Windows
        "$mainMod SHIFT, H, exec, ~/.config/hypr/move-windows.sh l"
        "$mainMod SHIFT, N, exec, ~/.config/hypr/move-windows.sh d"
        "$mainMod SHIFT, E, exec, ~/.config/hypr/move-windows.sh u"
        "$mainMod SHIFT, I, exec, ~/.config/hypr/move-windows.sh r"

        "$mainMod SHIFT, left, moveactive, -10 0"
        "$mainMod SHIFT, down, moveactive, 0 10"
        "$mainMod SHIFT, up, moveactive, 0 -10"
        "$mainMod SHIFT, right, moveactive, 10 0"

        # sets repeatable binds for resizing the active window
        "$mainMod CONTROL, H, resizeactive, -30 0"
        "$mainMod CONTROL, N, resizeactive, 0 30"
        "$mainMod CONTROL, E, resizeactive, 0 -30"
        "$mainMod CONTROL, I, resizeactive, 30 0"

        "$mainMod CONTROL, left, resizeactive, -10 0"
        "$mainMod CONTROL, right, resizeactive, 10 0"
        "$mainMod CONTROL, up, resizeactive, 0 -10"
        "$mainMod CONTROL, down, resizeactive, 0 10"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
    extraConfig = ''
    '';
  };
}
