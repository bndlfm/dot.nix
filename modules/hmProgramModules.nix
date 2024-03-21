{  pkgs, ... }:{

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
      interactiveShellInit = /* fish */ ''
        set PATH $PATH /home/neko/.local/bin

        set fish_greeting

        function fish_user_key_bindings --description 'vi-like key bindings for fish (Colemak adjusted)'
          # Execute this once per mode that emacs bindings should be used in
            fish_default_key_bindings -M insert

          # Then execute the vi-bindings so they take precedence
          # Without --no-erase fish_vi_key_bindings will reset all bindings.
            fish_vi_key_bindings --no-erase insert

          if contains -- -h $argv
            or contains -- --help $argv
            echo "Sorry but this function doesn't support -h or --help" >&2
            return 1
          end

          ## Adjust hjkl to hnei for navigation
            bind -s --preset -M default h backward-char
            bind -s --preset -M default n down-or-search
            bind -s --preset -M default e up-or-search
            bind -s --preset -M default i forward-char

          # Remap (Shift) H to go to the Beginning of Line and (Shift) I to go to the End of Line
            bind -s --preset -M default H beginning-of-line
            bind -s --preset -M default I end-of-line

          # Change k to act as i for insert mode
            bind -s --preset -m insert k repaint-mode

          # Use Ctrl-Y to accept suggested text and submit
            bind -s --preset -M insert \cy "commandline -f accept-autosuggestion execute"
        end

        set fish_default_key_bindings fish_user_key_bindings

        ## more fish vi key fixes
          set fish_cursor_insert line
          set fish_suggest_key_bindings yes

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
        rhm = "nvim ~/.nixcfg/home.nix";
        rnf = "nvim ~/.nixcfg/flake.nix";
        rnc = "nvim ~/.nixcfg/configuration.nix";

        ## ALIASES
        nxrb = "sudo nixos-rebuild switch --upgrade --impure --flake ~/.nixcfg";
        hmrb = "home-manager switch --flake ~/.nixcfg";

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
      extraConfig = /* zsh */ ''
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
        ##include themes/gruvbox_dark.conf
        ##background_opacity 0.87

        ### https://draculatheme.com/kitty
        ##foreground            #f8f8f2
        ##background            #282a36
        ##selection_foreground  #ffffff
        ##selection_background  #44475a

        ##url_color #8be9fd

        ### black
        ##color0  #21222c
        ##color8  #6272a4

        ### red
        ##color1  #ff5555
        ##color9  #ff6e6e

        ### green
        ##color2  #50fa7b
        ##color10 #69ff94

        ### yellow
        ##color3  #f1fa8c
        ##color11 #ffffa5

        ### blue
        ##color4  #bd93f9
        ##color12 #d6acff

        ### magenta
        ##color5  #ff79c6
        ##color13 #ff92df

        ### cyan
        ##color6  #8be9fd
        ##color14 #a4ffff

        ### white
        ##color7  #f8f8f2
        ##color15 #ffffff

        ### Cursor colors
        ##cursor            #f8f8f2
        ##cursor_text_color background

        ### Tab bar colors
        ##active_tab_foreground   #282a36
        ##active_tab_background   #f8f8f2
        ##inactive_tab_foreground #282a36
        ##inactive_tab_background #6272a4

        ### Marks
        ##mark1_foreground #282a36
        ##mark1_background #ff5555

        ### Splits/Windows
        ##active_border_color #f8f8f2
        ##inactive_border_color #6272a4
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
        yarn
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
    nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
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
}
