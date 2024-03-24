{pkgs,...}:{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = /* fish */ ''
        set PATH $PATH /home/neko/.local/bin

        set fish_greeting

        function fish_user_key_bindings --description 'Colemak vi-keys'
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
        { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
        {
          name = "fish-abbreviation-tips";
          src = pkgs.fetchFromGitHub {
            owner = "gazorby";
            repo = "fish-abbreviation-tips";
            rev = "8ed76a62bb044ba4ad8e3e6832640178880df485";
            sha256 = "05b5qp7yly7mwsqykjlb79gl24bs6mbqzaj5b3xfn3v2b7apqnqp";
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
          name = "fish-history-merge";
          src = pkgs.fetchFromGitHub {
            owner = "2m";
            repo = "fish-history-merge";
            rev = "7e415b8ab843a64313708273cf659efbf471ad39";
            sha256 = "1hlc2ghnc8xidwzj2v1rjrw7gbpkkkld9y2mg4dh2qmcvlizcbd3";
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
  };
}
