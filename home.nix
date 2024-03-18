{ pkgs, ... }:{

  imports = [ ];

  home.stateVersion = "23.11";
  home.username = "neko";
  home.homeDirectory = "/home/neko";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz")
          { inherit pkgs; };
      };
      permittedInsecurePackages = [
        "nix-2.16.2"
      ];
    };
    overlays = [
      #(import ./overlays/overlays.nix)
    ];
  };


  ######### (HM) SERVICES #########
  services = {
    arrpc.enable = true;
    espanso = {
      enable = true;
      package = pkgs.espanso;
      matches = {
        base = {
          matches = [
            { trigger = ":fflb"; replace = "firefliesandlightningbugs@gmail.com"; }
          ];
        };
      };
    };
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    mpd = {
      enable = true;
      musicDirectory = "~/Music";
    };
    mpd-discord-rpc.enable = true;
    flatpak = {
      packages = [
        "flathub:app/com.github.tchx84.Flatseal//stable"
        "flathub:app/app.getclipboard.Clipboard//stable"
        "flathub:app/md.obsidian.Obsidian//stable"
        "flathub:app/com.discordapp.Discord//stable"
      ];
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      };
    };
    wob.enable = true;
  };

  ######### (HM) ENVIRONMENT VARIABLES #########
  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_7}";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    NIXOS_OZONE_WL = "1";
    OBSIDIAN_REST_API_KEY = "3944368ac24bde98e46ee2d5b6425ce57d03399d799cdbc2453e10b8c407618a";
    QT_QPA_PLATFORM = "xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    STEAM_DISABLE_BROWSER_SHUTDOWN_WORKAROUND=1;
    SUDOEDITOR = "vim";
    VISUAL = "vim";
  };

  ######### (HM) THEMING ########
  gtk.cursorTheme = {
    name = "Volantes Light Cursors";
    package = pkgs.volantes-cursors;
  };
  #home.pointerCursor = {
  #  name = "volantes-cursors";
  #  package = pkgs.volantes-cursors;
  #  x11.defaultCursor = "volantes-cursors";
  #};

  ######### (HM) WAYLAND HYPRLAND ########
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
    };
    #plugins = with pkgs; [];
    settings = {
      "$mainMod" = "SUPER";
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

        # ofi
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
    extraConfig = /* sh */ ''
      #-------- Displays --------#
        monitor = HDMI-A-1, 1920x1080, 322x0, 1
        monitor = DP-1, disable
        monitor = DP-3, 2560x1440@144, 0x1080, 1, bitdepth, 10
        workspace = 10, monitor:HDMI-A-1, default:true
        workspace = 1, monitor:DP-3, default:true
        workspace = 7, monitor:DP-3


      #-------- Input --------#
        input {
          kb_layout = us
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =
          repeat_rate = 80
          repeat_delay = 280
          follow_mouse = 2
          mouse_refocus = false
          float_switch_override_focus = 0
          numlock_by_default = true
          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
          touchpad {
            natural_scroll = no
            }
          }


      #-------- ENV Variables --------#
        env = GBM_BACKEND, nvidia-drm
        env = GDK_BACKEND, wayland
        env = __GL_GSYNC_ALLOWED, 1
        env = __GL_VRR_ALLOWED, 1
        env = __GLX_VENDOR_LIBRARY_NAME, nvidia
        env = LIBVA_DRIVER_NAME, nvidia
        env = MOZ_ENABLE_WAYLAND, 1
        env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
        env = QT_QPA_PLATFORM, wayland
        env = VRR, 1
        env = vrr, 1
        env = WLR_NO_HARDWARE_CURSORS, 1
        env = WLR_DRM_NO_ATOMIC, 1
        env = XCURSOR_SIZE, 24
        env = XDG_SESSION_DESKTOP, hyprland
        env = XDG_SESSION_TYPE, wayland
        env = XDG_CURRENT_DESKTOP, hyprland


      #-------- Hyprland Variables --------#
        general {
          #See https://wiki.hyprland.org/Configuring/Variables/ for more
          allow_tearing = true
          gaps_in = 5
          gaps_out = 10
          border_size = 4
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)
          #layout = slidr
          layout = dwindle
          }
        decoration {
          rounding = 10
          drop_shadow = yes
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
          }
        animations {
          enabled = yes
          # Default, see https://wiki.hyprland.org/Configuring/Animations/
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          animation = windows, 1, 2, myBezier
          animation = windowsOut, 1, 2, default, popin 80%
          animation = border, 1, 2, default
          animation = borderangle, 1, 2, default
          animation = fade, 1, 2, default
          animation = workspaces, 1, 2, default
          }
        misc {
          vrr=1
          vfr=true
          }


      #-------- Core Autostart --------#
        exec-once = waybar
        exec-once = ibus-daemon
        exec-once = blueman-applet
        #exec-once = /usr/lib/polkit-kde-authentication-agent-1
        #exec-once = greenclip daemon
        #exec-once = /opt/safing/portmaster/portmaster-start core
        #exec-once = /opt/safing/portmaster/portmaster-start notifier
        exec-once = ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all


      #-------- User Autostart --------#
        #exec-once = gammastep -l 38.0628:-91.4035 -t 6500:4800
        exec-once = gammastep-indicator -l 38.0628:-91.4035 -t 6500:4800
        exec-once = ${pkgs.kdeconnect}/libexec/kdeconnectd
        exec-once = kdeconnect-indicator

        ## Power Saving (DPMS)
          ## Turn monitors off if locked (swaylock running) & idle for 10m
          exec-once = swayidle -w timeout 600 'if pgrep -x swaylock; then hyprctl dispatch dpms off; fi' resume 'hyprctl dispatch dpms on'

          ## Lock screen after idle for 900s and turn monitors off after 930
            exec-once = swayidle -w timeout 900 \
              'swaylock -f \
              --screenshots \
              --clock --indicator \
              --indicator-radius 100 \
              --indicator-thickness 7 \
              --effect-blur 7x5 \
              --effect-vignette 0.5:0.5 \
              --ring-color bb00cc \
              --key-hl-color 880033 \
              --line-color 00000000 \
              --inside-color 00000088 \
              --separator-color 00000000 \
              --grace 2 \
              --fade-in 0.2' \
              timeout 930 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'

        exec-once = swaybg
        exec-once = xrandr --output DP-3 --primary
        exec-once = ydotoold
        #exec-once = dbus-daemon --session --nofork --nopidfile --address=unix:path=/run/user/1000/bus
        exec-once = export $(dbus-launch)
        exec-once = systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE


      #-------- Window Rules --------#
        ## Chatterino/Streamlink-Twitch-GUI
          windowrule = workspace 10 silent, streamlink-twitch-gui
          windowrule = workspace 10 silent, chatterino
        ## Discord
          windowrule = workspace 10 silent, vencorddesktop
        ## File Pickers
          windowrulev2 = float, class:xdg-desktop-portal(.*)
          windowrulev2 = size 1060 960, title:(.*)(Select a)(.*)
          windowrulev2 = center, title:(.*)(Select a)(.*)
        ## MPV Picture-in-Picture
           windowrule = workspace 10, mpv_pip
           windowrule = float, mpv_pip
           windowrule = size 659 369, mpv_pip
           windowrule = move 416 33, mpv_pip
           windowrule = pin, mpv_pip
        ## Pin Entry (GPG)
          windowrulev2 = float, class:Pinentry(.*)
          windowrulev2 = center, class:Pinentry(.*)
        ## Steam
           windowrule = workspace 7 silent, steam
           windowrule = float, steam
           windowrulev2 = immediate, class:^(steam_app_(.*))
        ## qBittorrent
          windowrulev2 = workspace 9 silent, class:org.qbittorrent.qBittorrent
    '';
  };

  ######### (HM) DOTFILES ########
  home.file."nix.conf" = {
    target = ".config/nix/nix.conf";
    text = ''
      substituters = https://cache.nixos.org https://nix-gaming.cachix.org https://chaotic-nyx.cachix.org https://ezkea.cachix.org
      trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4= nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=
      '';
  };
  xdg.configFile = {
    "bspwm" = {
      source = ./.config/bspwm;
      recursive = true;
    };
    "hypr" = {
      source = ./.config/hypr;
      recursive = true;
    };
    "joshuto" = {
      source = ./.config/joshuto;
      recursive = true;
    };
    "mutt" = {
      source = ./.config/mutt;
      recursive = true;
    };
    #"nvim" = {
    #  source = ./.config/nvim;
    #  recursive = true;
    #};
    "polybar" = {
      source = ./.config/polybar;
      recursive = true;
    };
    "pulsemixer.cfg" = {
      source = ./.config/pulsemixer.cfg;
      recursive = false;
    };
    "ranger" = {
      source = ./.config/ranger;
      recursive = true;
    };
    "rofi" = {
      source = ./.config/rofi;
      recursive = true;
    };
    "sxhkd" = {
      source = ./.config/sxhkd;
      recursive = true;
    };
    "tridactyl" = {
      source = ./.config/tridactyl;
      recursive = true;
    };
    "qutebrowser" = {
      source = ./.config/qutebrowser;
      recursive = true;
    };
    "waybar" = {
      source = ./.config/waybar;
      recursive = true;
    };
    "yazi" = {
      source = ./.config/yazi;
      recursive = true;
    };
    "zathura" = {
      source = ./.config/zathura;
      recursive = true;
    };
  };
}

