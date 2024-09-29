{ pkgs, ... }: {
  home.packages = with pkgs; [
    ### HYPRLAND TOOLS
      clipse
      hdrop
      hyprpaper
      nwg-look
      nwg-displays
      hyprshot
      swaybg
      swayidle
      swaylock
      swaynotificationcenter
      wayland-utils
  ];

  ######### (HM) WAYLAND HYPRLAND ########
  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      enable = true;
    };

    plugins = with pkgs; [
    ];

    settings = {
  #-------- Startup --------#
    exec-once = [
      # Shibboleths for DBus / IBus
        "ibus-daemon"
        "systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE"
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all"
        "export $(dbus-launch)"
      ## Idleing stuff
        #  "swayidle -w timeout 600 'if pgrep -x swaylock; then hyprctl dispatch dpms off; fi' resume 'hyprctl dispatch dpms on'"
        #  "swayidle -w timeout 900 'swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2' timeout 930 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"
      ## Clipboard Shenanigans
        "copyq --start-server"
      ## KDE Connect
        "${pkgs.kdeconnect}/libexec/kdeconnect"
        "kdeconnect-indicator"
      "waybar"
      "blueman-applet" # Bluetooth
      "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse ~/GoogleDrive" # Google Drive
      "xrandr --output DP-1 --primary" # set Primary Monitor for Xwayland
      "gammastep-indicator -l 38.0628:-91.4035 -t 6500:4800" # (Night/Red/Blue)shift for wayland
      "hyprpaper"
      ];

    #-------- Window Rules --------#
      windowrule = [
        ## Chatterino/Streamlink-Twitch-GUI
          "workspace 10 silent, streamlink-twitch-gui"
          "workspace 10 silent, chatterino"
        ## Copyq Clipboard Manager
          "float, com.github.hluk.copyq"
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
        ## Clipboard
          "float, class:(clipse)"
          "size 622 652, class:(clipse)"
        ## File Pickers
          "float, class:xdg-desktop-portal(.*)"
          "size 1060 960, title:(.*)(Select a)(.*)"
          "center, title:(.*)(Select a)(.*)"
        ## FIREFOX Picture-in-Picture
          "float, class:^(firefox)$, title:(.*)(Picture-in-Picture)(.*)"
          "size 615 346, class:^(firefox)$, title:(.*)(Picture-in-Picture)(.*)"
          "move 1920 56, class:^(firefox)$, title:(.*)(Picture-in-Picture)(.*)"
          "noinitialfocus, class:^(firefox)$, title:(.*)(Picture-in-Picture)(.*)"
          # firefox-nightly
          "float, class:^(firefox-nightly)$, title:(.*)(Picture-in-Picture)(.*)"
          "size 615 346, class:^(firefox-nightly)$, title:(.*)(Picture-in-Picture)(.*)"
          "move 1920 56, class:^(firefox-nightly)$, title:(.*)(Picture-in-Picture)(.*)"
          "noinitialfocus, class:^(firefox-nightly)$, title:(.*)(Picture-in-Picture)(.*)"
        ## GPT FIREFOX
          "float, title:^(.*ChatGPTBox.*Firefox Developer Edition.*)$"
        ## Pin Entry (GPG)
          "float, class:Pinentry(.*)"
          "center, class:Pinentry(.*)"
        ## Steam
          "immediate, class:^(steam_app_(.*))"
        ## qBittorrent
          "workspace 9 silent, class:org.qbittorrent.qBittorrent"
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

        "$mainMod, S, togglefloating,"

        "$mainMod, F, fullscreen"
        "$mainMod CONTROL, F, exec, nautilus"
        "$mainMod, P, pseudo" # dwindle
        "$mainMod, J, togglesplit" # dwindle

        "$mainMod, GRAVE, exec, hdrop -f -b -g 30 kitty --class kittydrop"

        # Rofi
        "$mainMod, D, exec, wofi --show run"
        "$mainMod SHIFT, V, exec, copyq show"

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

        # Screenshot / Capture
        "SHIFT, PRINT, exec, hyprshot -m window"  # Screenshot a window
        ", PRINT, exec, hyprshot -m output"  # Screenshot a monitor
        "CONTROL, PRINT, exec, hyprshot -m region"  # Screenshot a region

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

      monitor = [
        "DP-1, 2560x1440@144, 1080x0, 1, bitdepth, 10"
        "DP-2, 1920x1080, 3640x0, 1, transform, 3"
        # See extraConfig below: "HDMI-A-1, 1920x1080, 0x0, 1, transform, 3"
      ];

      workspace = [
       "10, monitor:DP-2, default:true"
       "1, monitor:DP-1, default:true"
       "7, monitor:DP-1"
      ];

    #-------- Hyprland Variables --------#
      general = {
        # https://wiki.hyprland.org/Configuring/Variables/ for more
        allow_tearing = true;
        gaps_in = 5;
        gaps_out = 10;
        border_size = 4;
        layout = "dwindle";

        "col.active_border" = "rgba(99c0d0ff) rgba(5e81acff) 45deg";
        "col.inactive_border" = "rgba(2e3440ff)";
        "col.nogroup_border" = "rgba(60728aff)";
      };

      dwindle = {
        force_split = 2;
        preserve_split = true;
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
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
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
        "XCURSOR,volantes-cursors"
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
      misc = {
        vrr=1;
        vfr=true;
      };
    };

    extraConfig = ''
      monitor=HDMI-A-1, 1920x1080, 0x0, 1, transform, 3
    '';
  };
}
