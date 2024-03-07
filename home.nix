{ pkgs, ... }:

let
  homeDir = "/home/neko";
  system = "x86_64-linux";
in
{
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
        "electron-25.9.0"
      ];
    };
    overlays = [
      #(import ./overlays/overlays.nix)
    ];
  };

  home.packages = with pkgs; [
    ### CLI
    bat
    btop
    chafa
    eza
    fd
    file
    fzf
    git-lfs
    gnugrep
    libqalculate
    libnotify
    ollama
    pulsemixer
    ripgrep
    silver-searcher
    trashy
    xdragon
    winePackages.full

    ### EDITORS
    gimp

    ### GAMES
    crawlTiles
    lutris

    ### HYPRLAND
    hdrop
    hyprpaper
    hyprshot

    ### MEDIA
    mpd
    mpd-discord-rpc
    mpv
    ncmpcpp
    streamlink
    streamlink-twitch-gui-bin
    yt-dlp
    zathura

    ### PASSWORDS
    git-credential-gopass
    gopass

    ### PROGRAMMING
    python3
    nixd
    codeium
    direnv

    ### SWAY TOOLS
    swaybg
    swayidle
    swaylock
    swaynotificationcenter

    ### TUI
    joshuto
    page
    ranger
    highlight

    ### THEMING
    nerdfonts
    iosevka
    font-awesome
    ocs-url
    volantes-cursors
    dracula-theme
    base16-schemes

    ### Plasma5/QT5
    kdePackages.kio-gdrive
    plasma5Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct

    ### SYSTEM
    google-drive-ocamlfuse

    ### WAYLAND SPECIFIC
    gammastep
    grimblast
    slurp
    nwg-look
    waybar
    #wl-clipboard-x11
    #wl-clip-persist
    wlr-randr

    ### XORG
    dunst
    eww
    feh
    jgmenu
    polybar
    nitrogen
    scrot
    tdrop
    xorg.xkill
    xorg.xhost
    xclip

    ### MISC PACKAGES
    #arrpc
    brave
    direnv
    discordchatexporter-cli
    firefox-devedition
    speechd
    grc
    gparted
    kdeconnect
    lxappearance
    pavucontrol
    podman
    podman-compose
    qbittorrent
    ripcord
    rofi
    #upscayl
    yazi
    ydotool
    zip
    zoxide

  ];

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
        direnv hook fish | source
      '';
      plugins = [
        { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
        { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
        { name = "done"; src = pkgs.fishPlugins.done.src; }
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
        {
          name = "fish-history-merge";
          src = pkgs.fetchFromGitHub {
            owner = "2m";
            repo = "fish-history-merge";
            rev = "7e415b8ab843a64313708273cf659efbf471ad39";
            sha256 = "1hlc2ghnc8xidwzj2v1rjrw7gbpkkkld9y2mg4dh2qmcvlizcbd3";
          };
        }
        {
          name = "fish-fastdir";
          src = pkgs.fetchFromGitHub {
            owner = "danhper";
            repo = "fish-fastdir";
            rev = "dddc6c13b4afe271dd91ec004fdd199d3bbb1602";
            sha256 = "iu7zNO7yKVK2bhIIlj4UKHHqDaGe4q2tIdNgifxPev4=";
          };
        }
        {
          name = "virtualfish";
          src = pkgs.fetchFromGitHub {
            owner = "justinmayer";
            repo = "virtualfish";
            rev = "d280414a1862e4ebf22abf6b9939ebd48ddd4a58";
            sha256 = "1cn23vbribz3fj1nrm617fgzv81vmbx581j7xh2xxm5k7kmp770l";
          };
        }
        {
          name = "tacklebox";
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
        rcfshplug = "nvim ~/.nixcfg/.config/fish/fundle-plugins.fish";
        rcfsh = "nvim ~/.nixcfg/.config/fish/config.fish";
        rcfshabbr = "nvim ~/.nixcfg/.config/fish/abbr.fish";
        rcfshalias = "nvim ~/.nixcfg/.config/fish/alias.fish";

        ## WINDOW MANAGERS
        ## HYPRLAND
        rhyp = "nvim ~/.nixcfg/.config/hypr/hyprland.conf";
        rhppr = "nvim ~/.nixcfg/.config/hypr/hyprpaper.conf";
        rhdd = "nvim ~/.nixcfg/.config/hypr/dropdown.conf";
        rhddsh = "nvim ~/.nixcfg/.config/hypr/dropdown.sh";

        ## X WINDOW MANGERS
        rhlwm = "nvim ~/.nixcfg/.config/herbstluftwm/autostart";
        rbspwm = "nvim ~/.nixcfg/.config/bspwm/bspwmrc";
        rsxh = "nvim ~/.nixcfg/.config/sxhkd/sxhkdrc";

        ## OTHER CONFIG ABBR
        rpicom = "nvim ~/.nixcfg/.config/picom/picom-kawase.conf";
        rkt = "nvim ~/.nixcfg/.config/kitty/kitty.conf";
        rvm = "nvim ~/.nixcfg/.config/nvim/init.vim";
        rnvm = "nvim ~/.nixcfg/.config/nvim/init.vim";
        rsway = "nvim ~/.nixcfg/.config/sway/config";
        rtri = "nvim ~/.nixcfg/.config/tridactyl/tridactylrc";
        rwb = "nvim ~/.nixcfg/.config/waybar/config";

        ## NIX SPECIFIC
        ## EDIT CONFIGS
        rhm = "nvim ~/.nixcfg/home.nix";
        rnf = "nvim ~/.nixcfg/flake.nix";
        rnc = "nvim ~/.nixcfg/configuration.nix";

        ## ALIASES
        nxrb = "sudo nixos-rebuild switch --upgrade --impure --flake ~/.nixcfg";

        cb = "flatpak run app.getclipboard.Clipboard";

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
          helper = "${pkgs.git-credential-gopass}/bin/git-credential-manager";
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

        ### kitty-scrollback.nvim Kitten alias
          action_alias kitty_scrollback_nvim kitten ~/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py

          ### Browse scrollback buffer in nvim
          map ctrl+h kitten ~/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py

          ### Browse output of the last shell command in nvim
          map kitty_mod+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
          ### Show clicked command output in nvim
          mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output

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
      #extraConfig = ''
      #:luafile ~/.config/nvim/lazy_bootstrap.lua
      #'';
      extraPackages = with pkgs; [
        cargo
        dart
        eza
        fd
        fzf
        gcc
        git
        lua-language-server
        lazygit
        nodejs
        nodePackages.bash-language-server
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
        pyright
        python3
        python3Packages.pip
        tree-sitter
        ripgrep
        unzip
        wget
      ];
      plugins = with pkgs.vimPlugins; [
        vim-nix
        (nvim-treesitter.withPlugins (p: [
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
      enableZshIntegration = true;
      keymap = {
        manager.keymap = [
          { on = [ "<Esc>" ]; exec = "escape"; desc = "Exit visual mode, clear selected, or cancel search"; }
          { on = [ "q" ]; exec = "quit"; desc = "Exit the process"; }
          { on = [ "Q" ]; exec = "quit --no-cwd-file"; desc = "Exit the process without writing cwd-file"; }
          { on = [ "<C-q>" ]; exec = "close"; desc = "Close the current tab, or quit if it is last tab"; }
          { on = [ "<C-z>" ]; exec = "suspend"; desc = "Suspend the process"; }

          # NAVIGATION
          { on = [ "e" ]; exec = "arrow -1"; desc = "Move cursor up"; }
          { on = [ "n" ]; exec = "arrow 1"; desc = "Move cursor down"; }
          { on = [ "E" ]; exec = "arrow -5"; desc = "Move cursor up 5 lines"; }
          { on = [ "N" ]; exec = "arrow 5"; desc = "Move cursor down 5 lines"; }
          { on = [ "h" ]; exec = [ "leave" "escape --visual --select" ]; desc = "Go back to the parent directory"; }
          { on = [ "i" ]; exec = [ "enter" "escape --visual --select" ]; desc = "Enter the child directory"; }
          { on = [ "H" ]; exec = "back"; desc = "Go back to the previous directory"; }
          { on = [ "I" ]; exec = "forward"; desc = "Go forward to the next directory"; }
          { on = [ "<S-Up>" ]; exec = "arrow -5"; desc = "Move cursor up 5 lines"; }
          { on = [ "<S-Down>" ]; exec = "arrow 5"; desc = "Move cursor down 5 lines"; }

          { on = [ "<C-u>" ]; exec = "arrow -50%"; desc = "Move cursor up half page"; }
          { on = [ "<C-d>" ]; exec = "arrow 50%"; desc = "Move cursor down half page"; }
          { on = [ "<C-b>" ]; exec = "arrow -100%"; desc = "Move cursor up one page"; }
          { on = [ "<C-f>" ]; exec = "arrow 100%"; desc = "Move cursor down one page"; }

          { on = [ "<C-PageUp>" ]; exec = "arrow -50%"; desc = "Move cursor up half page"; }
          { on = [ "<C-PageDown>" ]; exec = "arrow 50%"; desc = "Move cursor down half page"; }
          { on = [ "<PageUp>" ]; exec = "arrow -100%"; desc = "Move cursor up one page"; }
          { on = [ "<PageDown>" ]; exec = "arrow 100%"; desc = "Move cursor down one page"; }

          # PREVIEW
          { on = [ "<A-e>" ]; exec = "seek -5"; desc = "Seek up 5 units in the preview"; }
          { on = [ "<A-n>" ]; exec = "seek 5"; desc = "Seek down 5 units in the preview"; }
          { on = [ "<A-PageUp>" ]; exec = "seek -5"; desc = "Seek up 5 units in the preview"; }
          { on = [ "<A-PageDown>" ]; exec = "seek 5"; desc = "Seek down 5 units in the preview"; }

          { on = [ "<Up>" ]; exec = "arrow -1"; desc = "Move cursor up"; }
          { on = [ "<Down>" ]; exec = "arrow 1"; desc = "Move cursor down"; }
          { on = [ "<Left>" ]; exec = "leave"; desc = "Go back to the parent directory"; }
          { on = [ "<Right>" ]; exec = "enter"; desc = "Enter the child directory"; }

          { on = [ "g" "g" ]; exec = "arrow -99999999"; desc = "Move cursor to the top"; }
          { on = [ "G" ]; exec = "arrow 99999999"; desc = "Move cursor to the bottom"; }

          # Selection
          { on = [ "<Space>" ]; exec = [ "select --state=none" "arrow 1" ]; desc = "Toggle the current selection state"; }
          { on = [ "v" ]; exec = "visual_mode"; desc = "Enter visual mode (selection mode)"; }
          { on = [ "V" ]; exec = "visual_mode --unset"; desc = "Enter visual mode (unset mode)"; }
          { on = [ "<C-a>" ]; exec = "select_all --state=true"; desc = "Select all files"; }
          { on = [ "<C-r>" ]; exec = "select_all --state=none"; desc = "Inverse selection of all files"; }

          # Operation
          { on = [ "o" ]; exec = "open"; desc = "Open the selected files"; }
          { on = [ "O" ]; exec = "open --interactive"; desc = "Open the selected files interactively"; }
          { on = [ "<Enter>" ]; exec = "open"; desc = "Open the selected files"; }
          { on = [ "<C-Enter>" ]; exec = "open --interactive"; desc = "Open the selected files interactively"; }
          { on = [ "y" ]; exec = "yank"; desc = "Copy the selected files"; }
          { on = [ "Y" ]; exec = "unyank"; desc = "Cancel the yank status of files"; }
          { on = [ "x" ]; exec = "yank --cut"; desc = "Cut the selected files"; }
          { on = [ "p" ]; exec = "paste"; desc = "Paste the files"; }
          { on = [ "P" ]; exec = "paste --force"; desc = "Paste the files (overwrite if the destination exists)"; }
          { on = [ "-" ]; exec = "link"; desc = "Symlink the absolute path of files"; }
          { on = [ "_" ]; exec = "link --relative"; desc = "Symlink the relative path of files"; }
          { on = [ "d" ]; exec = "remove"; desc = "Move the files to the trash"; }
          { on = [ "D" ]; exec = "remove --permanently"; desc = "Permanently delete the files"; }
          { on = [ "a" ]; exec = "create"; desc = "Create a file or directory (ends with / for directories)"; }
          { on = [ "r" ]; exec = "rename --cursor=before_ext"; desc = "Rename a file or directory"; }
          { on = [ ";" ]; exec = "shell"; desc = "Run a shell command"; }
          { on = [ ":" ]; exec = "shell --block"; desc = "Run a shell command (block the UI until the command finishes)"; }
          { on = [ "." ]; exec = "hidden toggle"; desc = "Toggle the visibility of hidden files"; }
          { on = [ "s" ]; exec = "search fd"; desc = "Search files by name using fd"; }
          { on = [ "S" ]; exec = "search rg"; desc = "Search files by content using ripgrep"; }
          { on = [ "<C-s>" ]; exec = "search none"; desc = "Cancel the ongoing search"; }
          { on = [ "z" ]; exec = "jump zoxide"; desc = "Jump to a directory using zoxide"; }
          { on = [ "Z" ]; exec = "jump fzf"; desc = "Jump to a directory; or reveal a file using fzf"; }

          # Linemode
          { on = [ "m" "s" ]; exec = "linemode size"; desc = "Set linemode to size"; }
          { on = [ "m" "p" ]; exec = "linemode permissions"; desc = "Set linemode to permissions"; }
          { on = [ "m" "m" ]; exec = "linemode mtime"; desc = "Set linemode to mtime"; }
          { on = [ "m" "n" ]; exec = "linemode none"; desc = "Set linemode to none"; }

          # Copy
          { on = [ "c" "c" ]; exec = "copy path"; desc = "Copy the absolute path"; }
          { on = [ "c" "d" ]; exec = "copy dirname"; desc = "Copy the path of the parent directory"; }
          { on = [ "c" "f" ]; exec = "copy filename"; desc = "Copy the name of the file"; }
          { on = [ "c" "n" ]; exec = "copy name_without_ext"; desc = "Copy the name of the file without the extension"; }

          # Filter
          { on = [ "f" ]; exec = "filter --smart"; desc = "Filter the files"; }

          # Find
          { on = [ "/" ]; exec = "find --smart"; desc = "Find next file"; }
          { on = [ "?" ]; exec = "find --previous --smart"; desc = "Find previous file"; }
          { on = [ "n" ]; exec = "find_arrow"; desc = "Go to next found file"; }
          { on = [ "N" ]; exec = "find_arrow --previous"; desc = "Go to previous found file"; }

          # Sorting
          { on = [ ";" "m" ]; exec = "sort modified --dir-first"; desc = "Sort by modified time"; }
          { on = [ ";" "M" ]; exec = "sort modified --reverse --dir-first"; desc = "Sort by modified time (reverse)"; }
          { on = [ ";" "c" ]; exec = "sort created --dir-first"; desc = "Sort by created time"; }
          { on = [ ";" "C" ]; exec = "sort created --reverse --dir-first"; desc = "Sort by created time (reverse)"; }
          { on = [ ";" "e" ]; exec = "sort extension --dir-first"; desc = "Sort by extension"; }
          { on = [ ";" "E" ]; exec = "sort extension --reverse --dir-first"; desc = "Sort by extension (reverse)"; }
          { on = [ ";" "a" ]; exec = "sort alphabetical --dir-first"; desc = "Sort alphabetically"; }
          { on = [ ";" "A" ]; exec = "sort alphabetical --reverse --dir-first"; desc = "Sort alphabetically (reverse)"; }
          { on = [ ";" "n" ]; exec = "sort natural --dir-first"; desc = "Sort naturally"; }
          { on = [ ";" "N" ]; exec = "sort natural --reverse --dir-first"; desc = "Sort naturally (reverse)"; }
          { on = [ ";" "s" ]; exec = "sort size --dir-first"; desc = "Sort by size"; }
          { on = [ ";" "S" ]; exec = "sort size --reverse --dir-first"; desc = "Sort by size (reverse)"; }

          # Tabs
          { on = [ "t" ]; exec = "tab_create --current"; desc = "Create a new tab using the current path"; }

          { on = [ "1" ]; exec = "tab_switch 0"; desc = "Switch to the first tab"; }
          { on = [ "2" ]; exec = "tab_switch 1"; desc = "Switch to the second tab"; }
          { on = [ "3" ]; exec = "tab_switch 2"; desc = "Switch to the third tab"; }
          { on = [ "4" ]; exec = "tab_switch 3"; desc = "Switch to the fourth tab"; }
          { on = [ "5" ]; exec = "tab_switch 4"; desc = "Switch to the fifth tab"; }
          { on = [ "6" ]; exec = "tab_switch 5"; desc = "Switch to the sixth tab"; }
          { on = [ "7" ]; exec = "tab_switch 6"; desc = "Switch to the seventh tab"; }
          { on = [ "8" ]; exec = "tab_switch 7"; desc = "Switch to the eighth tab"; }
          { on = [ "9" ]; exec = "tab_switch 8"; desc = "Switch to the ninth tab"; }

          { on = [ "[" ]; exec = "tab_switch -1 --relative"; desc = "Switch to the previous tab"; }
          { on = [ "]" ]; exec = "tab_switch 1 --relative"; desc = "Switch to the next tab"; }

          { on = [ "{" ]; exec = "tab_swap -1"; desc = "Swap the current tab with the previous tab"; }
          { on = [ "}" ]; exec = "tab_swap 1"; desc = "Swap the current tab with the next tab"; }

          # Tasks
          { on = [ "w" ]; exec = "tasks_show"; desc = "Show the tasks manager"; }

          # Goto
          { on = [ "g" "h" ]; exec = "cd ~"; desc = "Go to the home directory"; }
          { on = [ "g" "c" ]; exec = "cd ~/.config"; desc = "Go to the config directory"; }
          { on = [ "g" "d" ]; exec = "cd ~/Downloads"; desc = "Go to the downloads directory"; }
          { on = [ "g" "t" ]; exec = "cd /tmp"; desc = "Go to the temporary directory"; }
          { on = [ "g" "<Space>" ]; exec = "cd --interactive"; desc = "Go to a directory interactively"; }

          # Help
          { on = [ "~" ]; exec = "help"; desc = "Open help"; }

          # GOTO
          { on = [ "g" "h" ]; exec = "cd ~"; desc = "Go to the home directory"; }
          { on = [ "g" "c" ]; exec = "cd ~/.config"; desc = "Go to the config directory"; }
          { on = [ "g" "d" ]; exec = "cd ~/Downloads"; desc = "Go to the downloads directory"; }
          { on = [ "g" "t" ]; exec = "cd /tmp"; desc = "Go to the temporary directory"; }
          { on = [ "g" "<Space>" ]; exec = "cd --interactive"; desc = "Go to a directory interactively"; }
        ];
        tasks.keymap = [
          { on = [ "<Esc>" ]; exec = "close"; desc = "Hide the task manager"; }
          { on = [ "<C-q>" ]; exec = "close"; desc = "Hide the task manager"; }
          { on = [ "w" ]; exec = "close"; desc = "Hide the task manager"; }

          { on = [ "e" ]; exec = "arrow -1"; desc = "Move cursor up"; }
          { on = [ "n" ]; exec = "arrow 1"; desc = "Move cursor down"; }

          { on = [ "<Up>" ]; exec = "arrow -1"; desc = "Move cursor up"; }
          { on = [ "<Down>" ]; exec = "arrow 1"; desc = "Move cursor down"; }

          { on = [ "<Enter>" ]; exec = "inspect"; desc = "Inspect the task"; }
          { on = [ "x" ]; exec = "cancel"; desc = "Cancel the task"; }

          { on = [ "~" ]; exec = "help"; desc = "Open help"; }
        ];
        select.keymap = [
          { on = [ "<C-q>" ]; exec = "close"; desc = "Cancel selection"; }
          { on = [ "<Esc>" ]; exec = "close"; desc = "Cancel selection"; }
          { on = [ "<Enter>" ]; exec = "close --submit"; desc = "Submit the selection"; }

          { on = [ "e" ]; exec = "arrow -1"; desc = "Move cursor up"; }
          { on = [ "n" ]; exec = "arrow 1"; desc = "Move cursor down"; }

          { on = [ "E" ]; exec = "arrow -5"; desc = "Move cursor up 5 lines"; }
          { on = [ "N" ]; exec = "arrow 5"; desc = "Move cursor down 5 lines"; }

          { on = [ "<Up>" ]; exec = "arrow -1"; desc = "Move cursor up"; }
          { on = [ "<Down>" ]; exec = "arrow 1"; desc = "Move cursor down"; }

          { on = [ "<S-Up>" ]; exec = "arrow -5"; desc = "Move cursor up 5 lines"; }
          { on = [ "<S-Down>" ]; exec = "arrow 5"; desc = "Move cursor down 5 lines"; }

          { on = [ "~" ]; exec = "help"; desc = "Open help"; }
        ];
        input.keymap = [
          { on = [ "<C-q>" ]; exec = "close"; desc = "Cancel input"; }
          { on = [ "<Enter>" ]; exec = "close --submit"; desc = "Submit the input"; }
          { on = [ "<Esc>" ]; exec = "escape"; desc = "Go back the normal mode, or cancel input"; }

          # Mode
          { on = [ "i" ]; exec = "insert"; desc = "Enter insert mode"; }
          { on = [ "a" ]; exec = "insert --append"; desc = "Enter append mode"; }
          { on = [ "I" ]; exec = [ "move -999" "insert" ]; desc = "Move to the BOL; and enter insert mode"; }
          { on = [ "A" ]; exec = [ "move 999" "insert --append" ]; desc = "Move to the EOL; and enter append mode"; }
          { on = [ "v" ]; exec = "visual"; desc = "Enter visual mode"; }
          { on = [ "V" ]; exec = [ "move -999" "visual" "move 999" ]; desc = "Enter visual mode and select all"; }

          # Character-wise movement
          { on = [ "h" ]; exec = "move -1"; desc = "Move back a character"; }
          { on = [ "i" ]; exec = "move 1"; desc = "Move forward a character"; }

          { on = [ "<Left>" ]; exec = "move -1"; desc = "Move back a character"; }
          { on = [ "<Right>" ]; exec = "move 1"; desc = "Move forward a character"; }

          { on = [ "<C-b>" ]; exec = "move -1"; desc = "Move back a character"; }
          { on = [ "<C-f>" ]; exec = "move 1"; desc = "Move forward a character"; }

          # Word-wise Movement
          { on = [ "b" ]; exec = "backward"; desc = "Move back to the start of the current or previous word"; }
          { on = [ "w" ]; exec = "forward"; desc = "Move forward to the start of the next word"; }
          { on = [ "l" ]; exec = "forward --end-of-word"; desc = "Move forward to the end of the current or next word"; }
          { on = [ "<A-b>" ]; exec = "backward"; desc = "Move back to the start of the current or previous word"; }
          { on = [ "<A-f>" ]; exec = "forward --end-of-word"; desc = "Move forward to the end of the current or next word"; }

          # Line-wise movement
          { on = [ "0" ]; exec = "move -999"; desc = "Move to the BOL"; }
          { on = [ "$" ]; exec = "move 999"; desc = "Move to the EOL"; }
          { on = [ "<C-a>" ]; exec = "move -999"; desc = "Move to the BOL"; }
          { on = [ "<C-e>" ]; exec = "move 999"; desc = "Move to the EOL"; }
          { on = [ "<Home>" ]; exec = "move -999"; desc = "Move to the BOL"; }
          { on = [ "<End>" ]; exec = "move 999"; desc = "Move to the EOL"; }

          # Delete
          { on = [ "<Backspace>" ]; exec = "backspace"; desc = "Delete the character before the cursor"; }
          { on = [ "<Delete>" ]; exec = "backspace --under"; desc = "Delete the character under the cursor"; }
          { on = [ "<C-h>" ]; exec = "backspace"; desc = "Delete the character before the cursor"; }
          { on = [ "<C-d>" ]; exec = "backspace --under"; desc = "Delete the character under the cursor"; }

          # Kill
          { on = [ "<C-u>" ]; exec = "kill bol"; desc = "Kill backwards to the BOL"; }
          { on = [ "<C-k>" ]; exec = "kill eol"; desc = "Kill forwards to the EOL"; }
          { on = [ "<C-w>" ]; exec = "kill backward"; desc = "Kill backwards to the start of the current word"; }
          { on = [ "<A-d>" ]; exec = "kill forward"; desc = "Kill forwards to the end of the current word"; }

          # Cut/Yank/Paste
          { on = [ "d" ]; exec = "delete --cut"; desc = "Cut the selected characters"; }
          { on = [ "D" ]; exec = [ "delete --cut" "move 999" ]; desc = "Cut until the EOL"; }
          { on = [ "c" ]; exec = "delete --cut --insert"; desc = "Cut the selected characters; and enter insert mode"; }
          { on = [ "C" ]; exec = [ "delete --cut --insert" "move 999" ]; desc = "Cut until the EOL; and enter insert mode"; }
          { on = [ "x" ]; exec = [ "delete --cut" "move 1 --in-operating" ]; desc = "Cut the current character"; }
          { on = [ "y" ]; exec = "yank"; desc = "Copy the selected characters"; }
          { on = [ "p" ]; exec = "paste"; desc = "Paste the copied characters after the cursor"; }
          { on = [ "P" ]; exec = "paste --before"; desc = "Paste the copied characters before the cursor"; }

          # Undo/Redo
          { on = [ "u" ]; exec = "undo"; desc = "Undo the last operation"; }
          { on = [ "<C-r>" ]; exec = "redo"; desc = "Redo the last operation"; }

          # Help
          { on = [ "~" ]; exec = "help"; desc = "Open help"; }

          { on = [ "k" ]; exec = "insert"; desc = "Enter insert mode"; }
          { on = [ "K" ]; exec = [ "move -999" "insert" ]; desc = "Move to the BOL, and enter insert mode"; }
        ];
        completion.keymap = [
          { on = [ "<C-q>" ]; exec = "close"; desc = "Cancel completion"; }
          { on = [ "<Tab>" ]; exec = "close --submit"; desc = "Submit the completion"; }
          { on = [ "<Enter>" ]; exec = [ "close --submit" "close_input --submit" ]; desc = "Submit the completion and input"; }

          { on = [ "<A-k>" ]; exec = "arrow -1"; desc = "Move cursor up"; }
          { on = [ "<A-j>" ]; exec = "arrow 1"; desc = "Move cursor down"; }

          { on = [ "<Up>" ]; exec = "arrow -1"; desc = "Move cursor up"; }
          { on = [ "<Down>" ]; exec = "arrow 1"; desc = "Move cursor down"; }

          { on = [ "~" ]; exec = "help"; desc = "Open help"; }
        ];
        help.keymap = [
          { on = [ "e" ]; exec = "arrow -1"; desc = "Move cursor up"; }
          { on = [ "n" ]; exec = "arrow 1"; desc = "Move cursor down"; }
          { on = [ "E" ]; exec = "arrow -5"; desc = "Move cursor up 5 lines"; }
          { on = [ "N" ]; exec = "arrow 5"; desc = "Move cursor down 5 lines"; }

          { on = [ "<Esc>" ]; exec = "escape"; desc = "Clear the filter, or hide the help"; }
          { on = [ "q" ]; exec = "close"; desc = "Exit the process"; }
          { on = [ "<C-q>" ]; exec = "close"; desc = "Hide the help"; }

          # Navigation
          { on = [ "k" ]; exec = "arrow -1"; desc = "Move cursor up"; }
          { on = [ "j" ]; exec = "arrow 1"; desc = "Move cursor down"; }

          { on = [ "K" ]; exec = "arrow -5"; desc = "Move cursor up 5 lines"; }
          { on = [ "J" ]; exec = "arrow 5"; desc = "Move cursor down 5 lines"; }

          { on = [ "<Up>" ]; exec = "arrow -1"; desc = "Move cursor up"; }
          { on = [ "<Down>" ]; exec = "arrow 1"; desc = "Move cursor down"; }

          { on = [ "<S-Up>" ]; exec = "arrow -5"; desc = "Move cursor up 5 lines"; }
          { on = [ "<S-Down>" ]; exec = "arrow 5"; desc = "Move cursor down 5 lines"; }

          # Filtering
          { on = [ "/" ]; exec = "filter"; desc = "Apply a filter for the help items"; }
        ];
      };
      theme = {
        manager.theme = {
          cwd = { fg = "cyan"; };

          # Hovered
          hovered = { reversed = true; };
          preview_hovered = { underline = true; };

          # Find
          find_keyword = { fg = "yellow"; bold = true; italic = true; underline = true; };
          find_position = { fg = "magenta"; bg = "reset"; bold = true; italic = true; };

          # Marker
          marker_copied = { fg = "lightgreen"; bg = "lightgreen"; };
          marker_cut = { fg = "lightred"; bg = "lightred"; };
          marker_marked = { fg = "lightyellow"; bg = "lightyellow"; };
          marker_selected = { fg = "lightblue"; bg = "lightblue"; };

          # Tab
          tab_active = { fg = "black"; bg = "white"; };
          tab_inactive = { fg = "white"; bg = "darkgray"; };
          tab_width = 1;

          # Count
          count_copied = { fg = "black"; bg = "lightgreen"; };
          count_cut = { fg = "black"; bg = "lightred"; };
          count_selected = { fg = "black"; bg = "lightblue"; };

          # Border
          border_symbol = "*";
          border_style = { fg = "gray"; };

          # Highlighting
          syntect_theme = "";
        };
        status.theme = {
          separator_open = "";
          separator_close = "";
          separator_style = { fg = "darkgray"; bg = "darkgray"; };

          # Mode
          mode_normal = { fg = "black"; bg = "lightblue"; bold = true; };
          mode_select = { fg = "black"; bg = "lightgreen"; bold = true; };
          mode_unset = { fg = "black"; bg = "lightmagenta"; bold = true; };

          # Progress
          progress_label = { bold = true; };
          progress_normal = { fg = "blue"; bg = "black"; };
          progress_error = { fg = "red"; bg = "black"; };

          # Permissions
          permissions_t = { fg = "lightgreen"; };
          permissions_r = { fg = "lightyellow"; };
          permissions_w = { fg = "lightred"; };
          permissions_x = { fg = "lightcyan"; };
          permissions_s = { fg = "darkgray"; };
        };
        select.theme = {
          border = { fg = "blue"; };
          active = { fg = "magenta"; };
          inactive = { };
        };
        input.theme = {
          border = { fg = "blue"; };
          title = { };
          value = { };
          selected = { reversed = true; };
        };
        completion.theme = {
          border = { fg = "blue"; };
          active = { bg = "darkgray"; };
          inactive = { };

          # Icons
          icon_file = "";
          icon_folder = "";
          icon_command = "";
        };
        tasks.theme = {
          border = { fg = "blue"; };
          title = { };
          hovered = { underline = true; };
        };
        which.theme = {
          cols = 3;
          mask = { bg = "black"; };
          cand = { fg = "lightcyan"; };
          rest = { fg = "darkgray"; };
          desc = { fg = "magenta"; };
          separator = "  ";
          separator_style = { fg = "darkgray"; };
        };
        help.theme = {
          on = { fg = "magenta"; };
          exec = { fg = "cyan"; };
          desc = { fg = "gray"; };
          hovered = { bg = "darkgray"; bold = true; };
          footer = { fg = "black"; bg = "white"; };
        };
        filetype.theme = {
          rules = [
            # Images
            { mime = "image/*"; fg = "cyan"; }

            # Videos
            { mime = "video/*"; fg = "yellow"; }
            { mime = "audio/*"; fg = "yellow"; }

            # Archives
            { mime = "application/zip"; fg = "magenta"; }
            { mime = "application/gzip"; fg = "magenta"; }
            { mime = "application/x-tar"; fg = "magenta"; }
            { mime = "application/x-bzip"; fg = "magenta"; }
            { mime = "application/x-bzip2"; fg = "magenta"; }
            { mime = "application/x-7z-compressed"; fg = "magenta"; }
            { mime = "application/x-rar"; fg = "magenta"; }
            { mime = "application/xz"; fg = "magenta"; }

            # Documents
            { mime = "application/doc"; fg = "green"; }
            { mime = "application/pdf"; fg = "green"; }
            { mime = "application/rtf"; fg = "green"; }
            { mime = "application/vnd.*"; fg = "green"; }

            # Fallback
            # { name = "*", fg = "white" },
            { name = "*/"; fg = "blue"; }
          ];
        };
        icon.theme = {
          rules = [
            # Programming
            { name = "*.c"; text = ""; fg = "#599eff"; }
            { name = "*.cpp"; text = ""; fg = "#519aba"; }
            { name = "*.class"; text = ""; fg = "#cc3e44"; }
            { name = "*.cs"; text = "󰌛"; fg = "#596706"; }
            { name = "*.css"; text = ""; fg = "#42a5f5"; }
            { name = "*.elm"; text = ""; fg = "#4391d2"; }
            { name = "*.fish"; text = ""; fg = "#4d5a5e"; }
            { name = "*.go"; text = ""; fg = "#519aba"; }
            { name = "*.h"; text = ""; fg = "#a074c4"; }
            { name = "*.hpp"; text = ""; fg = "#a074c4"; }
            { name = "*.html"; text = ""; fg = "#e44d26"; }
            { name = "*.jar"; text = ""; fg = "#cc3e44"; }
            { name = "*.java"; text = ""; fg = "#cc3e44"; }
            { name = "*.js"; text = ""; fg = "#F1F134"; }
            { name = "*.jsx"; text = ""; fg = "#20c2e3"; }
            { name = "*.lua"; text = ""; fg = "#51a0cf"; }
            { name = "*.nix"; text = ""; fg = "#7ebae4"; }
            { name = "*.nu"; text = ">"; fg = "#3aa675"; }
            { name = "*.php"; text = ""; fg = "#a074c4"; }
            { name = "*.py"; text = ""; fg = "#ffbc03"; }
            { name = "*.rb"; text = ""; fg = "#701516"; }
            { name = "*.rs"; text = ""; fg = "#dea584"; }
            { name = "*.sbt"; text = ""; fg = "#4d5a5e"; }
            { name = "*.scala"; text = ""; fg = "#cc463e"; }
            { name = "*.scss"; text = ""; fg = "#f55385"; }
            { name = "*.sh"; text = ""; fg = "#4d5a5e"; }
            { name = "*.swift"; text = ""; fg = "#e37933"; }
            { name = "*.ts"; text = ""; fg = "#519aba"; }
            { name = "*.tsx"; text = ""; fg = "#1354bf"; }
            { name = "*.vim"; text = ""; fg = "#019833"; }
            { name = "*.vue"; text = "󰡄"; fg = "#8dc149"; }

            # Text
            { name = "*.conf"; text = ""; fg = "#6d8086"; }
            { name = "*.ini"; text = ""; fg = "#6d8086"; }
            { name = "*.json"; text = ""; fg = "#cbcb41"; }
            { name = "*.kdl"; text = ""; fg = "#6d8086"; }
            { name = "*.md"; text = ""; fg = "#ffffff"; }
            { name = "*.toml"; text = ""; fg = "#ffffff"; }
            { name = "*.txt"; text = ""; fg = "#89e051"; }
            { name = "*.yaml"; text = ""; fg = "#6d8086"; }
            { name = "*.yml"; text = ""; fg = "#6d8086"; }

            # Archives
            { name = "*.7z"; text = ""; }
            { name = "*.bz2"; text = ""; }
            { name = "*.gz"; text = ""; }
            { name = "*.rar"; text = ""; }
            { name = "*.tar"; text = ""; }
            { name = "*.xz"; text = ""; }
            { name = "*.zip"; text = ""; }

            # Images
            { name = "*.HEIC"; text = ""; fg = "#a074c4"; }
            { name = "*.avif"; text = ""; fg = "#a074c4"; }
            { name = "*.bmp"; text = ""; fg = "#a074c4"; }
            { name = "*.gif"; text = ""; fg = "#a074c4"; }
            { name = "*.ico"; text = ""; fg = "#cbcb41"; }
            { name = "*.jpeg"; text = ""; fg = "#a074c4"; }
            { name = "*.jpg"; text = ""; fg = "#a074c4"; }
            { name = "*.png"; text = ""; fg = "#a074c4"; }
            { name = "*.svg"; text = ""; fg = "#FFB13B"; }
            { name = "*.webp"; text = ""; fg = "#a074c4"; }

            # Movies
            { name = "*.avi"; text = ""; fg = "#FD971F"; }
            { name = "*.mkv"; text = ""; fg = "#FD971F"; }
            { name = "*.mov"; text = ""; fg = "#FD971F"; }
            { name = "*.mp4"; text = ""; fg = "#FD971F"; }
            { name = "*.webm"; text = ""; fg = "#FD971F"; }

            # Audio
            { name = "*.aac"; text = ""; fg = "#66D8EF"; }
            { name = "*.flac"; text = ""; fg = "#66D8EF"; }
            { name = "*.m4a"; text = ""; fg = "#66D8EF"; }
            { name = "*.mp3"; text = ""; fg = "#66D8EF"; }
            { name = "*.ogg"; text = ""; fg = "#66D8EF"; }
            { name = "*.wav"; text = ""; fg = "#66D8EF"; }

            # Documents
            { name = "*.csv"; text = ""; fg = "#89e051"; }
            { name = "*.doc"; text = ""; fg = "#185abd"; }
            { name = "*.doct"; text = ""; fg = "#185abd"; }
            { name = "*.docx"; text = ""; fg = "#185abd"; }
            { name = "*.dot"; text = ""; fg = "#185abd"; }
            { name = "*.ods"; text = ""; fg = "#207245"; }
            { name = "*.ots"; text = ""; fg = "#207245"; }
            { name = "*.pdf"; text = ""; fg = "#b30b00"; }
            { name = "*.pom"; text = ""; fg = "#cc3e44"; }
            { name = "*.pot"; text = ""; fg = "#cb4a32"; }
            { name = "*.potx"; text = ""; fg = "#cb4a32"; }
            { name = "*.ppm"; text = ""; fg = "#a074c4"; }
            { name = "*.ppmx"; text = ""; fg = "#cb4a32"; }
            { name = "*.pps"; text = ""; fg = "#cb4a32"; }
            { name = "*.ppsx"; text = ""; fg = "#cb4a32"; }
            { name = "*.ppt"; text = ""; fg = "#cb4a32"; }
            { name = "*.pptx"; text = ""; fg = "#cb4a32"; }
            { name = "*.xlc"; text = ""; fg = "#207245"; }
            { name = "*.xlm"; text = ""; fg = "#207245"; }
            { name = "*.xls"; text = ""; fg = "#207245"; }
            { name = "*.xlsm"; text = ""; fg = "#207245"; }
            { name = "*.xlsx"; text = ""; fg = "#207245"; }
            { name = "*.xlt"; text = ""; fg = "#207245"; }

            # Lockfiles
            { name = "*.lock"; text = ""; fg = "#bbbbbb"; }

            # Misc
            { name = "*.bin"; text = ""; fg = "#9F0500"; }
            { name = "*.exe"; text = ""; fg = "#9F0500"; }
            { name = "*.pkg"; text = ""; fg = "#9F0500"; }

            # Dotfiles
            { name = ".DS_Store"; text = ""; fg = "#41535b"; }
            { name = ".bashprofile"; text = ""; fg = "#89e051"; }
            { name = ".bashrc"; text = ""; fg = "#89e051"; }
            { name = ".gitattributes"; text = ""; fg = "#41535b"; }
            { name = ".gitignore"; text = ""; fg = "#41535b"; }
            { name = ".gitmodules"; text = ""; fg = "#41535b"; }
            { name = ".vimrc"; text = ""; fg = "#019833"; }
            { name = ".zprofile"; text = ""; fg = "#89e051"; }
            { name = ".zshenv"; text = ""; fg = "#89e051"; }
            { name = ".zshrc"; text = ""; fg = "#89e051"; }

            # Named files
            { name = "COPYING"; text = "󰿃"; fg = "#cbcb41"; }
            { name = "Containerfile"; text = "󰡨"; fg = "#458ee6"; }
            { name = "Dockerfile"; text = "󰡨"; fg = "#458ee6"; }
            { name = "LICENSE"; text = "󰿃"; fg = "#d0bf41"; }

            # Directories
            { name = ".config/"; text = ""; }
            { name = ".git/"; text = ""; }
            { name = "Desktop/"; text = ""; }
            { name = "Development/"; text = ""; }
            { name = "Documents/"; text = ""; }
            { name = "Downloads/"; text = ""; }
            { name = "Library/"; text = ""; }
            { name = "Movies/"; text = ""; }
            { name = "Music/"; text = ""; }
            { name = "Pictures/"; text = ""; }
            { name = "Public/"; text = ""; }
            { name = "Videos/"; text = ""; }

            # Default
            { name = "*"; text = ""; }
            { name = "*/"; text = ""; }
          ];
        };
      };
    };
  };

  ######### (HM) SERVICES #########
  services = {
    arrpc.enable = true;
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
    flatpak = {
      #enable = true;
      packages = [
        #{ appId = "com.discordapp.Discord"; origin = "flathub"; }
        #"md.obsidian.Obsidian"
        "flathub:app/com.github.tchx84.Flatseal//stable"
        "flathub:app/app.getclipboard.Clipboard//stable"
        "flathub:app/md.obsidian.Obsidian//stable"
        "flathub:app/com.discordapp.Discord//stable"
      ];
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      };
      #uninstallUnmanagedPackages = true;
      #update.auto = {
      #enable = true;
      #onCalendar = "weekly";
      #};
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
    SUDOEDITOR = "vim";
    VISUAL = "vim";
  };

  ######### (HM) THEMING ########
  #gtk.cursorTheme = {
  #  name = "volantes-cursors";
  #  package = pkgs.volantes-cursors;
  #};
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
    "nvim" = {
      source = ./.config/nvim;
      recursive = true;
    };
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

