{ config, pkgs, ... }:

let
  homeDir = "/home/${config.home.username}";
in
{
  imports = [
    #<sops-nix/modules/home-manager/sops.nix>
  ];

  home.stateVersion = "23.11";
  home.username = "neko";
  home.homeDirectory = "/home/neko";

#---- Enable Unfree Packages ----#
  nixpkgs.config = {
    allowUnfree = true;
    #allowUnfreePredicate = (_: true);
    };

#-------- PACKAGES --------#
  home.packages = with pkgs; [
  ## PACKAGE GROUPS
    ## CLI
      btop
      carapace
      eza
      fd
      fzf
      gnugrep
      pulsemixer
      ranger
      ripgrep
      silver-searcher
      trashy
    ## EDITORS
      blender
      gimp
    ## HYPRLAND
      hdrop
      hyprpaper
      hyprshot
    ## MEDIA
      freetube
      mpd
      mpd-discord-rpc
      mpv
      ncmpcpp
      yt-dlp
    ## PASSWORDS
      git-credential-manager
      gopass
      pass
      pass-git-helper
    ## RICE
      libsForQt5.qt5ct
      nerdfonts
      ocs-url
      plasma5Packages.qtstyleplugin-kvantum
      volantes-cursors
    ## SWAY TOOLS
      swaybg
      swayidle
      swaylock
      swaynotificationcenter
    ## WAYLAND SPECIFIC
      grimblast
      slurp
      nwg-look
      wine
      wl-clipboard
      wl-clipboard-x11
      wl-clip-persist
      wlr-randr
    ## XORG
      xorg.xkill
      xorg.xhost
  ## MISC PACKAGES
    arrpc
    discord
    distrobox
    firefox
    flatpak
    gparted
    kdeconnect
    nvidia-podman
    lxappearance
    lutris
    obsidian
    pavucontrol
    podman
    podman-compose
    qbittorrent
    ripcord
    qutebrowser-qt5
    rofi
    steam-run
    upscayl
    vulkan-tools
    yadm
    yams
    ydotool
    zoxide
  ];

# -------- HM Modules --------#
  programs = {
    bash = {
      bashrcExtra = "exec fish";
      };
    broot = {
      enable = true;
      enableFishIntegration = true;
      };
    carapace = {
      enable = true;
      enableFishIntegration = true;
      };
    dircolors = {
      enable = true;
      enableFishIntegration = true;
      };
    firefox = {
      enable = true;
      #nativeMessagingHosts.packages = with pkgs {
        #pkgs.tridactyl-native.enable = true;
        #pkgs.plasma-browser-integration
        #pkgs.browserpass
      };
    fish = {
      enable = true;
      plugins = [
        { name = "async-prompt"; src = pkgs.fishPlugins.async-prompt; }
        { name = "autopair"; src = pkgs.fishPlugins.autopair; }
        { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages; }
        { name = "done"; src = pkgs.fishPlugins.done; }
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish; }
        { name = "grc"; src = pkgs.fishPlugins.grc; }
        { name = "plugin-git"; src = pkgs.fishPlugins.plugin-git; }
        { name = "sponge"; src = pkgs.fishPlugins.sponge; }
        { name = "tide"; src = pkgs.fishPlugins.tide; }
        { name = "fish-history-merge";
          src = pkgs.fetchFromGitHub {
            owner = "2m";
            repo = "fish-history-merge";
            rev = "7e415b8ab843a64313708273cf659efbf471ad39";
            sha256 = "1hlc2ghnc8xidwzj2v1rjrw7gbpkkkld9y2mg4dh2qmcvlizcbd3";
            };
          }
        ];
      interactiveShellInit = ''
        set PATH $PATH /home/neko/.local/bin

        set fish_greeting

        ## to load vi-keys and overwrite
        ## shared bindings w/r/t emac binds
        set fish_hybrid_key_bindings

        ## more fish vi key fixes
        set fish_cursor_insert line
        set fish_suggest_key_bindings yes

        # Check if fundle is installed, if not install
        if not functions -q fundle
            eval (curl -sfL https://git.io/fundle-install)
        end

        ###########################
        ##     ABBREVIATIONS     ##
        ###########################
          abbr del trash
          abbr rm "rm -Iv"

        #------------------- EDIT CONFIG --------------------#
          ## FISH SHELL
            abbr rcfshplug "nvim $XDG_CONFIG_HOME/fish/fundle-plugins.fish"
            abbr rcfsh "nvim $XDG_CONFIG_HOME/fish/config.fish"
            abbr rcfshabbr "nvim $XDG_CONFIG_HOME/fish/abbr.fish"
            abbr rcfshalias "nvim $XDG_CONFIG_HOME/fish/alias.fish"

          ## WINDOW MANAGERS
            ## HYPRLAND
              abbr rchypr "nvim $XDG_CONFIG_HOME/hypr/hyprland.conf"
              abbr rchyprpaper "nvim $XDG_CONFIG_HOME/hypr/hyprpaper.conf"
              abbr rchydd "nvim $XDG_CONFIG_HOME/hypr/dropdown.conf"
              abbr rchyddsh "nvim $XDG_CONFIG_HOME/hypr/dropdown.sh"

            ## X WINDOW MANGERS
              abbr rchlwm "nvim $XDG_CONFIG_HOME/herbstluftwm/autostart"
              abbr rcbspwm "nvim $XDG_CONFIG_HOME/bspwm/bspwmrc"
              abbr rcsxhkd "nvim $XDG_CONFIG_HOME/sxhkd/sxhkdrc"

          ## OTHER CONFIG ABBR
            abbr rcpicom "nvim $XDG_CONFIG_HOME/picom/picom-kawase.conf"
            abbr rckit "nvim $XDG_CONFIG_HOME/kitty/kitty.conf"
            abbr rcvim "nvim $XDG_CONFIG_HOME/nvim/init.vim"
            abbr rcnvim "nvim $XDG_CONFIG_HOME/nvim/init.vim"
            abbr rcsway "nvim $XDG_CONFIG_HOME/sway/config"
            abbr rctri "nvim $XDG_CONFIG_HOME/tridactyl/tridactylrc"
            abbr rcwayb "nvim $XDG_CONFIG_HOME/waybar/config"

          ## NIX SPECIFIC
            ## EDIT CONFIGS
            abbr rchmh "nvim ~/.dotfiles/.config/home-manager/home.nix"
            abbr rchmf "nvim ~/.dotfiles/.config/home-manager/flake.nix"
            abbr rcnixc "nvim ~/.dotfiles/system-config/configuration.nix"

            ## ALIASES
            abbr hmsi "home-manager switch --impure"
            abbr norsu "sudo nixos-rebuild switch --upgrade"

        #------------------- (G)O TO DIR --------------------#
          abbr gfsh --position anywhere --set-cursor "$XDG_CONFIG_HOME/fish/%"
          abbr gtri --position anywhere --set-cursor "$XDG_CONFIG_HOME/tridactyl/%"
          abbr ghyp --position anywhere --set-cursor "$XDG_CONFIG_HOME/hypr/%"
          abbr gvi --position anywhere --set-cursor "$XDG_CONFIG_HOME/nvim/%"

          abbr gloc --position anywhere --set-cursor "$HOME/.local/%"
          abbr gconf --position anywhere --set-cursor "$HOME/.config/%"

          abbr gbin --position anywhere --set-cursor "$HOME/.local/bin/%"
          abbr gcont --position anywhere --set-cursor "$HOME/.local/containers/%"

        #----------------- CURL SHENANIGANS -----------------#
          ## CHEAT.SH
          abbr cht --set-cursor "curl cht.sh/%"
          abbr cheat --set-cursor "curl cht.sh/%"

          abbr wttr "curl wttr.in"

          abbr gIPv4-way "bash -c 'curl icanhazip.com | tee >(wl-copy)'"
          abbr gIPv4-x11 "bash -c 'curl icanhazip.com | xclip -i -selection clipboard'"

        #----------------- GENERAL SHORTCUTS ----------------#
          abbr g git
          abbr c clear
          abbr ls "eza --group-directories-first --icons --color-scale all"
          abbr suvi sudoedit
          abbr yay "nix search nixpkgs"
          abbr pass gopass

        #----------------- PLUGINS ----------------#
          fundle plugin jethrokuan/z
          fundle plugin ajeetdsouza/zoxide
          fundle plugin 'PatrickF1/fzf.fish'
          fundle plugin franciscolourenco/done
          fundle plugin 'jorgebucaran/autopair.fish'
          fundle plugin tuvistavie/fish-fastdir
          fundle plugin 2m/fish-history-merge
          #fundle plugin gazorby/fifc
          fundle plugin justinmayer/virtualfish
          fundle plugin jomik/fish-gruvbox

          fundle init

        zoxide init fish | source
        carapace chmod fish | source
        '';
        };
    fzf = {
      enable = true;
      enableFishIntegration = true;
      };
    git = {
      userName = "bndlfm";
      userEmail = "firefliesandlightningbugs@gmail.com";
      };
    kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      shellIntegration.enableFishIntegration = true;
      extraConfig = ''
        font_family      Inconsolata LGC Nerd Font Mono
        bold_font        Inconsolata LGC Nerd Font Mono Bold
        italic_font      Inconsolata LGC Nerd Font Mono Italic
        bold_italic_font Inconsolata LGC Nerd Font Mono Bold Italic

        font_size 13.0

        scrollback_lines 100000

        scrollback_pager ~/.config/kitty/pager.sh 'INPUT_LINE_NUMBER' 'CURSOR_LINE' 'CURSOR_COLUMN'
        mouse_hide_wait 0

        copy_on_select yes

        sync_to_monitor yes

        enable_audio_bell yes
        window_alert_on_bell yes
        bell_on_tab yes

        window_border_width 0.0

        draw_minimal_borders yes

        single_window_margin_width -1000.0

        window_padding_width 0.0

        placement_strategy center

        hide_window_decorations yes

        tab_bar_edge bottom
        tab_bar_style custom
        tab_bar_min_tabs 2
        # tab_switch_strategy previous
        tab_fade 0.25 0.5 0.75 1

        tab_separator ""
        tab_title_template " {index}: {title} "

        active_tab_title_template " {index}: {title} "
        active_tab_font_style    bold
        inactive_tab_font_style  italic

        dynamic_background_opacity yes

        shell fish

        allow_remote_control yes
        listen_on unix:/tmp/kitty

        clipboard_control write-clipboard write-primary read-clipboard read-primary no-append

        linux_display_server auto

        kitten_alias hints hints --hints-offset=0

        map ctrl+c copy_or_interrupt 

        map kitty_mod+v  paste_from_clipboard
        map kitty_mod+s  paste_from_selection
        map shift+insert paste_from_selection
        map kitty_mod+o  pass_selection_to_program
        map kitty_mod+y new_window less @selection

        map kitty_mod+up        scroll_line_up
        map kitty_mod+down      scroll_line_down
        map kitty_mod+page_up   scroll_page_up
        map kitty_mod+page_down scroll_page_down
        map kitty_mod+home      scroll_home
        map kitty_mod+end       scroll_end
        map control+h           show_scrollback

        map ctrl+alt+enter    launch --cwd=current

        map kitty_mod+1 first_window
        map kitty_mod+2 second_window
        map kitty_mod+3 third_window
        map kitty_mod+4 fourth_window
        map kitty_mod+5 fifth_window
        map kitty_mod+6 sixth_window
        map kitty_mod+7 seventh_window
        map kitty_mod+8 eighth_window
        map kitty_mod+9 ninth_window
        map kitty_mod+0 tenth_window

        map kitty_mod+i     next_tab
        map kitty_mod+h     previous_tab
        map kitty_mod+t     new_tab
        map kitty_mod+q     close_tab
        map kitty_mod+.     move_tab_forward
        map kitty_mod+,     move_tab_backward
        map kitty_mod+alt+t set_tab_title

        map kitty_mod+equal     change_font_size all +1.0
        map kitty_mod+minus     change_font_size all -1.0
        map kitty_mod+backspace change_font_size all 0

        map kitty_mod+f>p kitten hints --type path --program -
        map kitty_mod+f>c kitten hints --type path --program @
        map kitty_mod+e kitten hints
        map kitty_mod+f>o kitten hints --type path
        map kitty_mod+f>l kitten hints --type line --program -
        map kitty_mod+f>w kitten hints --type word --program -
        map kitty_mod+f>h kitten hints --type hash --program -

        #: Select something that looks like filename:linenum and open it in
        #: vim at the specified line number.
        map kitty_mod+f>n kitten hints --type linenum

        map kitty_mod+/      launch --allow-remote-control kitty +kitten kitty_search/search.py @active-kitty-window-id
        map kitty_mod+k      kitten unicode_input

        map kitty_mod+a>m    set_background_opacity +0.1
        map kitty_mod+a>l    set_background_opacity -0.1
        map kitty_mod+a>1    set_background_opacity 1
        map kitty_mod+a>d    set_background_opacity default

        map kitty_mod+delete clear_terminal reset active

        map kitty_mod+d detach_tab ask

        map kitty_mod+f9 clear_terminal reset active
        map kitty_mod+f10 clear_terminal clear active
        map kitty_mod+f11 clear_terminal scrollback active
        map kitty_mod+f12 clear_terminal scroll active

        map ctrl+l combine : clear_terminal scroll active : send_text normal,application \x0c
        # to fix fish vi keys
        shell_integration no-cursor

        # Looks
        include themes/gruvbox_dark.conf
        background_opacity 0.87

        # https://draculatheme.com/kitty

        foreground            #f8f8f2
        background            #282a36
        selection_foreground  #ffffff
        selection_background  #44475a

        url_color #8be9fd

        # black
        color0  #21222c
        color8  #6272a4

        # red
        color1  #ff5555
        color9  #ff6e6e

        # green
        color2  #50fa7b
        color10 #69ff94

        # yellow
        color3  #f1fa8c
        color11 #ffffa5

        # blue
        color4  #bd93f9
        color12 #d6acff

        # magenta
        color5  #ff79c6
        color13 #ff92df

        # cyan
        color6  #8be9fd
        color14 #a4ffff

        # white
        color7  #f8f8f2
        color15 #ffffff

        # Cursor colors
        cursor            #f8f8f2
        cursor_text_color background

        # Tab bar colors
        active_tab_foreground   #282a36
        active_tab_background   #f8f8f2
        inactive_tab_foreground #282a36
        inactive_tab_background #6272a4

        # Marks
        mark1_foreground #282a36
        mark1_background #ff5555

        # Splits/Windows
        active_border_color #f8f8f2
        inactive_border_color #6272a4
        '';
      };
    ncmpcpp = {
      enable = true;
      };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = ''
        :luafile ~/.config/nvim/lazy_bootstrap.lua
        '';
      extraPackages = with pkgs; [
        dart
        eza
        fd
        fzf
        gcc
        git
        lua-language-server
        lazygit
        nil
        nodejs
        nodePackages.bash-language-server
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
        pyright
        python3
        tree-sitter
        ripgrep
        unzip
        wget
        ];
      plugins = with pkgs.vimPlugins; [
        vim-nix
        ( nvim-treesitter.withPlugins (p: [
          p.bash
          p.c
          p.cpp
          p.lua
          p.nix
          p.python
          p.rust
          p.typescript
          ]))
        ];
      };
    waybar = {
      enable = true;
      systemd.enable = true;
    };
    };
#-------- SERVICES --------#
  services = {
    mpd = {
      enable = true;
      musicDirectory = "~/Music";
      };
    mpd-discord-rpc.enable = true;
    };
#-------- ENVIRONMENT VARIABLES --------#
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    NIXPKGS_ALLOW_INSECURE = 1;
    SUDOEDITOR = "nvim";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    };
#-------- WAYLAND HYPRLAND --------#
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      #variables = [
        #"GBM_BACKEND, nvidia-drm"
        #"GDK_BACKEND, wayland"
        #"__GL_GSYNC_ALLOWED, 1"
        #"__GL_VRR_ALLOWED, 1"
        #"__GLX_VENDOR_LIBRARY_NAME, nvidia"
        #"LIBVA_DRIVER_NAME, nvidia"
        #"MOZ_ENABLE_WAYLAND, 1"
        #"QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        #"QT_QPA_PLATFORM, wayland"
        #"VRR, 1"
        #"vrr, 1"
        #"WLR_NO_HARDWARE_CURSORS, 1"
        #"WLR_DRM_NO_ATOMIC, 1"
        #"XCURSOR_SIZE, 24"
        #"XDG_SESSION_DESKTOP, hyprland"
        #"XDG_SESSION_TYPE, wayland"
        #"XDG_CURRENT_DESKTOP, hyprland "
        #"allow_workspace_cycles, true"
        #];
      };
    #plugins = {};
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
         "$mainMod, P, pseudo"  # dwindle
         "$mainMod, J, togglesplit"  # dwindle

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
          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
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
        exec-once = ibus-daemon
        exec-once = blueman-applet
        #exec-once = /usr/lib/polkit-kde-authentication-agent-1
        #exec-once = greenclip daemon
        #exec-once = /opt/safing/portmaster/portmaster-start core
        #exec-once = /opt/safing/portmaster/portmaster-start notifier
      #-------- User Autostart --------#
        exec-once = /usr/lib/kdeconnectd
        exec-once = kdeconnect-indicator
        #exec-once = streamlink-twitch-gui --tray

        #Power Saving (DPMS)
          #Turn monitors off if locked (swaylock running) & idle for 10m
          exec-once = swayidle -w timeout 600 'if pgrep -x swaylock; then hyprctl dispatch dpms off; fi' resume 'hyprctl dispatch dpms on'

          #Lock screen after idle for 900s and turn monitors off after 930
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
#-------- DOTFILES -------#
  xdg.configFile = {
    "qutebrowser" = {
      source = "~/.dotfiles/.config/qutebrowser";
      recursive = true;
      };
    "hypr" = {
      source = "~/.dotfiles/.config/hypr";
      recursive = true;
      };
    };
}

#exec-once = ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all

# vim: fdm=expr fde=nvim_treesitter#foldexpr() fdls=2
