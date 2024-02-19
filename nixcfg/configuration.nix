# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:


{
  imports = [
    ./hardware-configuration.nix
    #<home-manager/nixos>
    ];


#-------- HOME MANAGER --------#
  home-manager.users.neko = { pkgs, ... }:
    let
      homeDir = "${config.users.users.neko.home}";
    in
    {
      home.stateVersion = "23.11";
      home.username = "neko";
      home.homeDirectory = "/home/neko";

    ######### (HM) PACKAGES ########
      ## Enable Unfree Packages
      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
        packageOverrides = pkgs: {
          nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") 
          {
            inherit pkgs;
          };
        };
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
      };

      home.packages = with pkgs; [
        ## PACKAGE GROUPS
          ## EDITORS
            blender
            gimp
          ## GAMES
            crawlTiles
          ## HYPRLAND
            hdrop
            hyprpaper
            hyprshot
          ## MEDIA
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
          ## PROGRAMMING
            python3
          ## SWAY TOOLS
            swaybg
            swayidle
            swaylock
            swaynotificationcenter
          ## TERMINAL
            ## CLI
              bat
              btop
              carapace
              chafa
              devbox
              eza
              fd
              fzf
              gnugrep
              libqalculate
              ollama
              pulsemixer
              ripgrep
              silver-searcher
              supabase-cli
              trashy
            ## TUI
              joshuto
              ranger
              yazi
          ## THEMING
            nerdfonts
            ocs-url
            volantes-cursors
            dracula-theme
          ## QT
            plasma5Packages.qtstyleplugin-kvantum
            libsForQt5.qtstyleplugin-kvantum
            #libsForQt5.plasma-browser-integration
            libsForQt5.qt5ct
          ## WAYLAND SPECIFIC
            gammastep
            grimblast
            slurp
            nwg-look
            waybar
            wine
            #wl-clipboard
            #wl-clipboard-x11
            #wl-clip-persist
            wlr-randr
          ## XORG
            xorg.xkill
            xorg.xhost
            xclip

          ## MISC PACKAGES
            #arrpc
            brave
            discordchatexporter-cli
            dotnet-runtime_7
            #( firefox-devedition-unwrapped.override {
            #  patches = oldAttrs.patches ++ [
            #    (builtins.fetchurl "${self}/patches/firefox/ext-tabs.js.patch")
            #    (builtins.fetchurl "${self}/patches/firefox/tabs.json.patch")
            #    ];
            #})
            flatpak
            grc
            gparted
            kdeconnect
            lxappearance
            lutris
            obsidian
            pavucontrol
            podman
            podman-compose
            qbittorrent
            ripcord
            rofi
            steam-run
            #upscayl
            yadm
            yams
            yazi
            ydotool
            web-ext
            zip
            zoxide
            ];

    ######### (HM) PROGRAM MODULES #########
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
        fish = {
          enable = true;
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

            zoxide init fish | source
            carapace _carapace fish | source
            '';
          plugins = [
            { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
            { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
            { name = "done"; src = pkgs.fishPlugins.done.src; }
            { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
            { name = "grc"; src = pkgs.fishPlugins.grc.src; }
            #{ name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
            { name = "fish-history-merge";
              src = pkgs.fetchFromGitHub {
                owner = "2m";
                repo = "fish-history-merge";
                rev = "7e415b8ab843a64313708273cf659efbf471ad39";
                sha256 = "1hlc2ghnc8xidwzj2v1rjrw7gbpkkkld9y2mg4dh2qmcvlizcbd3";
                };
              }
            { name = "fish-fastdir";
              src = pkgs.fetchFromGitHub {
                owner = "danhper";
                repo = "fish-fastdir";
                rev = "dddc6c13b4afe271dd91ec004fdd199d3bbb1602";
                sha256 = "iu7zNO7yKVK2bhIIlj4UKHHqDaGe4q2tIdNgifxPev4=";
                };
              }
            { name = "virtualfish";
              src = pkgs.fetchFromGitHub {
                owner = "justinmayer";
                repo = "virtualfish";
                rev = "d280414a1862e4ebf22abf6b9939ebd48ddd4a58";
                sha256 = "1cn23vbribz3fj1nrm617fgzv81vmbx581j7xh2xxm5k7kmp770l";
                };
              }
            { name = "tacklebox";
              src = pkgs.fetchFromGitHub {
                owner = "justinmayer";
                repo = "tacklebox";
                rev = "1c13cecd5748013be89373ab087dac94e861598d";
                sha256 = "BGFPnGdF/wmnJH8YJqyBi4Pb6DlPM509fj+GnTnWkQc=";
                };
              }
            ];
          shellAbbrs = {
            #_________ EDIT CONFIG ________#
              ## FISH SHELL
                rcfshplug = "nvim ~/fish/fundle-plugins.fish";
                rcfsh = "nvim ~/fish/config.fish";
                rcfshabbr = "nvim ~/fish/abbr.fish";
                rcfshalias = "nvim ~/fish/alias.fish";

              ## WINDOW MANAGERS
                ## HYPRLAND
                  rchypr = "nvim ~/hypr/hyprland.conf";
                  rchyprpaper = "nvim ~/hypr/hyprpaper.conf";
                  rchydd = "nvim ~/hypr/dropdown.conf";
                  rchyddsh = "nvim ~/hypr/dropdown.sh";

                ## X WINDOW MANGERS
                  rchlwm = "nvim ~/herbstluftwm/autostart";
                  rcbspwm = "nvim ~/bspwm/bspwmrc";
                  rcsxhkd = "nvim ~/sxhkd/sxhkdrc";

              ## OTHER CONFIG ABBR
                rcpicom = "nvim ~/picom/picom-kawase.conf";
                rckit = "nvim ~/kitty/kitty.conf";
                rcvim = "nvim ~/nvim/init.vim";
                rcnvim = "nvim ~/nvim/init.vim";
                rcsway = "nvim ~/sway/config";
                rctri = "nvim ~/tridactyl/tridactylrc";
                rcwayb = "nvim ~/waybar/config";

              ## NIX SPECIFIC
                ## EDIT CONFIGS
                 rchmh = "nvim ~/.dotfiles/.config/home-manager/home.nix";
                 rchmf = "nvim ~/.dotfiles/.config/home-manager/flake.nix";
                 rcnixc = "nvim ~/.dotfiles/system-config/configuration.nix";

                ## ALIASES
                 nosru = "sudo nixos-rebuild switch --upgrade --impure --flake ~/.dotfiles/nixcfg/";

            #________ (G)O TO DIR ________# 
              gfsh = { position = "anywhere"; setCursor = true; expansion = "~/.config/fish/%"; };
              gtri = { position = "anywhere"; setCursor = true; expansion = "~/.config/tridactyl/%"; };
              ghyp = { position = "anywhere"; setCursor = true; expansion = "~/.config/hypr/%"; };
              gvi = { position = "anywhere"; setCursor = true; expansion = "~/.config/nvim/%"; };

              gloc = { position = "anywhere"; setCursor = true; expansion = "~/.local/%"; };
              gconf = { position = "anywhere"; setCursor = true; expansion = "~/.config/%"; };

              gbin = { position = "anywhere"; setCursor = true; expansion = "~/.local/bin/%"; };
              gcont = { position = "anywhere"; setCursor = true; expansion = "~/.local/containers/%"; };

            #________ CURL SHENANIGANS ________#
              ## CHEAT.SH
              cht = { setCursor = true; expansion = "curl cht.sh/%"; };
              cheat = { setCursor = true; expansion = "curl cht.sh/%"; };

              wttr = "curl wttr.in";

              gIPv4-way = "bash -c 'curl icanhazip.com | tee >(wl-copy)'";
              gIPv4-x11 = "bash -c 'curl icanhazip.com | xclip -i -selection clipboard'";

            #________ GENERAL SHORTCUTS ________#
              g = "git";
              c = "clear";
              del = "trash";
              rm = "rm -Iv";
              ls = "eza --group-directories-first --icons --color-scale all";
              suvi = "sudoedit";
              yay = "nix search nixpkgs";
              pass = "gopass";
            };
          };
        fzf = {
          enable = true;
          enableFishIntegration = true;
          };
        git = {
          userName = "bndlfm";
          userEmail = "firefliesandlightningbugs@gmail.com";
          extraConfig = {
            credential = {
              credentialStore = "secretservice";
              helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
              };
            };
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

            font_size 14.0

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
        yazi = {
          enable = true;
          enableFishIntegration = true;
          enableBashIntegration = true;
          keymap = {
            manager.keymap = [
              # Navigation
              { on = [ "e" ]; exec = "arrow -1"; desc = "Move cursor up"; }
              { on = [ "n" ]; exec = "arrow 1";  desc = "Move cursor down"; }
              { on = [ "E" ]; exec = "arrow -5"; desc = "Move cursor up 5 lines"; }
              { on = [ "N" ]; exec = "arrow 5";  desc = "Move cursor down 5 lines"; }
              { on = [ "h" ]; exec = [ "leave" "escape --visual --select" ]; desc = "Go back to the parent directory"; }
              { on = [ "i" ]; exec = [ "enter" "escape --visual --select" ]; desc = "Enter the child directory"; }
              { on = [ "H" ]; exec = "back";    desc = "Go back to the previous directory"; }
              { on = [ "I" ]; exec = "forward"; desc = "Go forward to the next directory"; }

              { on = [ "<A-e>" ]; exec = "seek -5"; desc = "Seek up 5 units in the preview"; }
              { on = [ "<A-n>" ]; exec = "seek 5";  desc = "Seek down 5 units in the preview"; }
              { on = [ "t" ]; exec = "tab_create --current"; desc = "Create a new tab using the current path"; }

              ## Goto
              { on = [ "g" "h" ];       exec = "cd ~";             desc = "Go to the home directory"; }
              { on = [ "g" "c" ];       exec = "cd ~/.config";     desc = "Go to the config directory"; }
              { on = [ "g" "d" ];       exec = "cd ~/Downloads";   desc = "Go to the downloads directory"; }
              { on = [ "g" "t" ];       exec = "cd /tmp";          desc = "Go to the temporary directory"; }
              { on = [ "g" "<Space>" ]; exec = "cd --interactive"; desc = "Go to a directory interactively"; }
              ];

            tasks.keymap = [
              { on = [ "e" ]; exec = "arrow -1"; desc = "Move cursor up"; }
              { on = [ "n" ]; exec = "arrow 1";  desc = "Move cursor down"; }
              ];

            select.keymap = [
              { on = [ "e" ]; exec = "arrow -1"; desc = "Move cursor up"; }
              { on = [ "n" ]; exec = "arrow 1";  desc = "Move cursor down"; }
              { on = [ "E" ]; exec = "arrow -5"; desc = "Move cursor up 5 lines"; }
              { on = [ "N" ]; exec = "arrow 5";  desc = "Move cursor down 5 lines"; }
              ];

            input.keymap = [
              { on = [ "<Esc>" ]; exec = "escape"; desc = "Go back the normal mode, or cancel input"; }

              # Mode
              { on = [ "k" ]; exec = "insert";                              desc = "Enter insert mode"; }
              { on = [ "K" ]; exec = [ "move -999" "insert" ];             desc = "Move to the BOL, and enter insert mode"; }

              # Character-wise movement
              { on = [ "h" ];       exec = "move -1"; desc = "Move back a character"; }
              { on = [ "i" ];       exec = "move 1";  desc = "Move forward a character"; }

              # Word-wise movement
              { on = [ "b" ];     exec = "backward";              desc = "Move back to the start of the current or previous word"; }
              { on = [ "w" ];     exec = "forward";               desc = "Move forward to the start of the next word"; }
              { on = [ "l" ];     exec = "forward --end-of-word"; desc = "Move forward to the end of the current or next word"; }
              ];

            help.keymap = [
              { on = [ "<Esc>" ]; exec = "escape"; desc = "Clear the filter, or hide the help"; }
              { on = [ "q" ];     exec = "close";  desc = "Exit the process"; }
              { on = [ "<C-q>" ]; exec = "close";  desc = "Hide the help"; }

              # Navigation
              { on = [ "e" ]; exec = "arrow -1"; desc = "Move cursor up"; }
              { on = [ "n" ]; exec = "arrow 1";  desc = "Move cursor down"; }

              { on = [ "E" ]; exec = "arrow -5"; desc = "Move cursor up 5 lines"; }
              { on = [ "N" ]; exec = "arrow 5";  desc = "Move cursor down 5 lines"; }
              ];
            };
          };

        };

    ######### (HM) SERVICES #########
      services = {
        espanso = {
          enable = true;
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
        };

    ######### (HM) ENVIRONMENT VARIABLES #########
      home.sessionVariables = {
        EDITOR = "nvim";
        MANPAGER = "nvim +Man!";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "xcb";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        SUDOEDITOR = "vim";
        VISUAL = "vim";
        };

    ######### (HM) THEMING ########
      gtk.cursorTheme = {
        name = "volantes-cursors";
        package = pkgs.volantes-cursors;
        };
      home.pointerCursor = {
        name = "volantes-cursors";
        package = pkgs.volantes-cursors;
        x11.defaultCursor = pkgs.volantes-cursors;
        };

    ######### (HM) WAYLAND HYPRLAND ########
      wayland.windowManager.hyprland = {
        enable = true;
        systemd = {
          enable = true;
          };
        plugins = with pkgs; [];
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
          plugin = /home/neko/.config/hypr/plugins/hyprslidr.so
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
      xdg.configFile = {
        #"fish" = {
        #  source = "${homeDir}/.dotfiles/.config/fish";
        #  recursive = true;
        #  };
        "hypr" = {
          source = "${homeDir}/.dotfiles/.config/hypr";
          recursive = true;
          };
        "joshuto" = {
          source = "${homeDir}/.dotfiles/.config/joshuto";
          recursive = true;
          };
        "mutt" = {
          source = "${homeDir}/.dotfiles/.config/mutt";
          recursive = true;
          };
        "pulsemixer.cfg" = {
          source = "${homeDir}/.dotfiles/.config/pulsemixer.cfg";
          recursive = true;
          };
        "ranger" = {
          source = "${homeDir}/.dotfiles/.config/ranger";
          recursive = true;
          };
        "rofi" = {
          source = "${homeDir}/.dotfiles/.config/rofi";
          recursive = true;
          };
        "tridactyl" = {
          source = "${homeDir}/.dotfiles/.config/tridactyl";
          recursive = true;
          };
        "qutebrowser" = {
          source = "${homeDir}/.dotfiles/.config/qutebrowser";
          recursive = true;
          };
        "waybar" = {
          source = "${homeDir}/.dotfiles/.config/waybar";
          recursive = true;
          };
        "yazi" = {
          source = "${homeDir}/.dotfiles/.config/yazi";
          recursive = true;
          };
        };
      };

#    services.podman.containers = {
#      "jellyfin" = {
#        image = "docker.io/jellyfin/jellyfin:latest";
#        description = "media server";
#        labels = {
#          "io.containers.autoupdate" = "registry";
#          };
#        autoStart = true;
#        ports = [
#          "8096:8096"
#          "8920:8920"
#          "1900:1900"
#          "7359:7359"
#          ];
#        environment = {
#          NVIDIA_VISIBLE_DEVICES="all";
#          NVIDIA_DRIVER_CAPABILITIES="all";
#          JELLYFIN_PublishedServerUrl="192.168.1.5";
#          };
#        volumes = [
#          "/media/.cache:/cache"
#          "/media/.jellyfin:/config"
#          "/media:/media"
#          ];
#        };
#      };
#-------- PACKAGES --------#
  nix.settings.experimental-features = [ "nix-command" "flakes" ];  # Enable Flakes
  nixpkgs.config = {
    allowUnfree = true;  # Allow non-foss pkgs
    cudaSupport = true;
    };
  
  environment.systemPackages = with pkgs; [
    git
    btrfs-progs
    docker
    home-manager
    hyprland
    hyprland-protocols
    neovim-unwrapped
    runc
    sops
    ];

#-------- PACKAGE MODULES --------#
programs = {
  firefox = {
    enable = true;
    #package = firefox-devedition-unwrapped;
    nativeMessagingHosts.packages = with pkgs; [
      tridactyl-native
      browserpass
      #plasma-browser-integration
      ff2mpv
      ];
    };
  gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    };
  hyprland = {
    enable = true;
    xwayland.enable = true;
    };
  nix-ld = {
    enable = true;
    libraries = with pkgs; [
      cmake
      ];
    };
  steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports firewall for Source Dedicated Server
    };
  };

#-------- CONTAINERS / VM --------#
  virtualisation = {
    containers.enable = true;
    containers.storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        rootless_storage_path = "/tmp/containers-$USER";
        options.overlay.mountopt = "nodev,metacopy=on";
        };
      };
    docker = {
      enable = true;
      enableNvidia = true;
      enableOnBoot = true;
      extraOptions = "--default-runtime=nvidia";
      #listenOptions = [
      #  "/var/run/docker.sock"
      #  ];
      #rootless = {
      #  enable= true;
        #setSocketVariable = true;
      #  };
      #  storageDriver = "overlay";
      };
    podman = {
      enable = true;
      enableNvidia = true;
      #dockerSocket.enable = true;
      #defaultNetwork.settings.dns_enabled = true;
      };
    libvirtd.enable = true;
    oci-containers = {
      backend = "podman";
      containers."jellyfin" = {
        image = "docker.io/jellyfin/jellyfin:latest";
        labels = {
          "io.containers.autoupdate" = "registry";
          };
        autoStart = true;
        ports = [
          "8096:8096"
          "8920:8920"
          "1900:1900"
          "7359:7359"
          ];
        environment = {
          NVIDIA_VISIBLE_DEVICES="all";
          NVIDIA_DRIVER_CAPABILITIES="all";
          JELLYFIN_PublishedServerUrl="192.168.1.5";
          };
        volumes = [
          "/media/.cache:/cache"
          "/media/.jellyfin:/config"
          "/media:/media"
          ];
        };
      };
    };
    #environment.extraInit = ''
      #if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
        #export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
        #fi
      #'';



#-------- GROUPS ---------#
  users.groups.distrobox = {};
  users.groups.steamhead = {};


#-------- USERS --------#
  ##########################
  # Don't forget password! #
  ##########################
  users.users.neko = {
    isNormalUser = true;
    description = "neko";
    extraGroups = [ "networkmanager" "wheel" "input" "docker" "libvirtd" ];
    packages = with pkgs; [
      ];
    };

  users.users.distrobox = {
    isSystemUser = true;
    description = "distrobox user";
    group = "distrobox";
    };

  users.users.steamhead = {
    isSystemUser = true;
    description = "What it says on the can bitch!";
    group = "steamhead";
    };


#-------- SERVICES --------#
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      };

    ## Enable Flatpak
    flatpak.enable = true;

    ## Enable the OpenSSH daemon.
    openssh.enable = true;

    ## Enable CUPS to print documents.
    printing.enable = true;

    ## X11
    xserver = {
      enable = true;
      #displayManager.gdm.enable = true;
      #desktopManager.gnome.enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      # Configure keymap in X11
      xkb.layout = "us";
      xkb.variant = "";
      };
    };


#-------- SYSTEM --------#
  systemd = {
    enableUnifiedCgroupHierarchy = false;
    user = {
      services = {
        polkit-gnome-authentication-agent-1 = {
          description = "polkit-gnome-authentication-agent-1";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
            };
          };
        ytoold.enable = true;
        };
      };
    extraConfig = ''
      DefaultTimeoutStopSec = 10s
      '';
    };

#-------- FILESYSTEM --------#
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/627b1de1-05e5-4596-8b3a-a009597f5ed6";
    fsType = "btrfs";
    options = [
      "noatime"
      "nodiratime"
      "discard"
      ];
    };
  fileSystems."/media" = {
    device = "/dev/disk/by-uuid/fe4494de-0116-404f-9c8a-5011115eedbf";
    fsType = "btrfs";
    options = [
      "subvol=@media"
      "noatime"
      "nodiratime"
      "discard"
      ];
    };


#-------- NETWORKING --------#
  networking = {
    hostName = "meow";
    networkmanager.enable = true;  # Enable Networking
    firewall = {
      enable = true;
      ## Open ports in the firewall.
      allowedTCPPorts = [ 8000 8096 ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
        ];
      allowedUDPPorts = [];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
        ];
      };
    };


#-------- AUDIO --------#
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    ## use the example session manager (no others are packaged yet so this is
    ## enabled by default, no need to redefine it in your config for now)
    #media-session.enable = true;
    };


#-------- GPU --------#
  hardware.nvidia = {
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # Setup displays
  services.xserver.displayManager.setupCommands =
    let
      monitor-center = "DP-4";
      monitor-top = "HDMI-A-1";
    in
    ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output ${monitor-center} --primary --mode 2560x1440 --pos 0x1080 --rate 144.00 --rotate normal --output ${monitor-top} --mode 1920x1080 --rate 60.00 --pos 322x0 ${monitor-center}
    '';


#-------- BOOTLOADER --------#
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      #grub.enable = true;
      #grub.device = "/dev/nvme0n1p1";
      };
    extraModprobeConfig = ''
      '';
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "nvidia.modesetting=1" ];
    kernel.sysctl = { "vm.overcommit_memory" = 1; };
    #blacklistedKernelModules = [ "nouveau" ];
    };

#-------- POWER --------#
  powerManagement.enable = false;

#-------- XDG PORTALS --------#
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      ];
    config = {
      common = {
        default = [
          "kde"
          "gtk"
        ];
      };
      kde = {
        default = [
          "kde"
          "gtk"
        ];
      };
      gnome = {
        default = [
          "gtk"
          "kde"
        ];
      };
      hyprland = {
        default = [
          "hyprland"
          "kde"
          ];
        };
      };
    };


#-------- TZ/i18n --------#
  # Set your time zone.
  time.timeZone = "America/Chicago";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    };




##############################################################################
## This value determines the NixOS release from which the default           ##
## settings for stateful data, like file locations and database versions    ##
## on your system were taken. It‘s perfectly fine and recommended to leave  ##
## this value at the release version of the first install of this system.   ##
## Before changing this value read the documentation for this option        ##
## (e.g. man configuration.nix or on https://nixos.org/nixos/options.html). ##
##############################################################################
  system.stateVersion = "23.11"; # Did you read the comment?
}
