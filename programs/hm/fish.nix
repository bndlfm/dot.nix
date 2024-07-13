{pkgs,...}:{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = /* fish */ ''
        set PATH $PATH /home/neko/.local/bin
        set fish_greeting

        function fish_user_key_bindings --description 'Colemak vi-keys'
            fish_default_key_bindings -M insert
            fish_vi_key_bindings --no-erase insert # Without --no-erase fish_vi_key_bindings will reset all bindings.

            if contains -- -h $argv
                or contains -- --help $argv
                echo "Sorry but this function doesn't support -h or --help" >&2
                return 1
            end

            ## ADJUST HJKL TO HNEI FOR NAVIGATION
                bind -s --preset -M default h backward-char
                bind -s --preset -M default n down-or-search
                bind -s --preset -M default e up-or-search
                bind -s --preset -M default i forward-char

            ## REMAP (SHIFT) H TO GO TO THE bEGINNING OF lINE AND (SHIFT) I TO GO TO THE END OF LINE
                bind -s --preset -M default H beginning-of-line
                bind -s --preset -M default I end-of-line

            # CHANGE K TO ACT AS I FOR INSERT MODE
                bind -s --preset -m insert k repaint-mode

            # USE CTRL-Y TO ACCEPT SUGGESTED TEXT AND SUBMIT
                bind -s --preset -M insert \cy "commandline -f accept-autosuggestion execute"

            # CODEX.FISH OPENAI CODEX PLUGIN
                bind --erase -M insert --preset \cx
                bind --erase -M visual --preset \cx
                bind --erase --preset \cx
                bind -M insert \cx create_completion
                bind -M visual \cx create_completion
        end

        ## more fish vi key fixes
            set fish_default_key_bindings fish_user_key_bindings
            set fish_cursor_insert line
            set fish_suggest_key_bindings yes

        ## shell indicators (nix-shell, python-venv, etc)
            set -l nix_shell_info (
              if test -n "$IN_NIX_SHELL"
                echo -n "<nix-shell> "
              end
            )

        zoxide init fish | source
        carapace _carapace fish | source
        direnv hook fish | source
      '';
      functions = {
        mkcd = ''
          if test (count $argv) -eq 1
            mkdir -p $argv[1] && cd $argv[1]
          else
            echo 'Usage: mkcd <directory>'
          end
        '';
      };
      plugins = [
        #{ name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
        { name = "pisces"; src = pkgs.fishPlugins.pisces.src; }
        { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
        { name = "done"; src = pkgs.fishPlugins.done.src; }
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
        { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
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
          name = "fish-ai";
          src = pkgs.fetchFromGitHub {
            owner = "Realiserad";
            repo = "fish-ai";
            rev = "9c40b4af5d837565be803dd15a6f85671ec29884";
            sha256 = "NTGIBFoYdYZWf2YF5Di2/rYBtGHy4qpOiIvGMn/sh+A=";
          };
        }
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
        {
          name = "tacklebox";
          src = pkgs.fetchFromGitHub {
            owner = "justinmayer";
            repo = "tacklebox";
            rev = "1c13cecd5748013be89373ab087dac94e861598d";
            sha256 = "BGFPnGdF/wmnJH8YJqyBi4Pb6DlPM509fj+GnTnWkQc=";
          };
        }
        { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      ];
      shellAbbrs = {
        ###############
        # EDIT CONFIG #
        ###############
          rchpp = "nvim ~/.nixcfg/.config/hypr/hyprpaper.conf";

        ## X WINDOW MANGERS
          rsxh = "nvim ~/.nixcfg/.config/sxhkd/sxhkdrc";

        ## OTHER CONFIG ABBR
          rtri = "nvim ~/.nixcfg/.config/tridactyl/tridactylrc";
          rwb = "nvim ~/.nixcfg/.config/waybar/config";

        ## NIX SPECIFIC
          rhmc = "nvim ~/.nixcfg/home.nix";
          rhmp = "nvim ~/.nixcfg/modules/hmPackages.nix";
          rhmP = "nvim ~/.nixcfg/modules/hmPrograms.nix";
          rnxf = "nvim ~/.nixcfg/flake.nix";
          rnxc = "nvim ~/.nixcfg/configuration.nix";

          nxgc = "sudo nix-collect-garbage -d";
          hmgc = "nix-collect-garbage -d";

        ## ALIASES
          nxrb = "sudo nixos-rebuild switch --upgrade --flake ~/.nixcfg";
          hmrb = "home-manager switch --flake ~/.nixcfg -b bak --impure";


        ###############
        # (G)O TO DIR #
        ###############
          gfsh = { position = "anywhere"; setCursor = true; expansion = "~/.config/fish/%"; };
          gtri = { position = "anywhere"; setCursor = true; expansion = "~/.config/tridactyl/%"; };
          ghyp = { position = "anywhere"; setCursor = true; expansion = "~/.config/hypr/%"; };
          gvi = { position = "anywhere"; setCursor = true; expansion = "~/.config/nvim/%"; };

          gloc = { position = "anywhere"; setCursor = true; expansion = "~/.local/%"; };
          gconf = { position = "anywhere"; setCursor = true; expansion = "~/.config/%"; };
          gbin = { position = "anywhere"; setCursor = true; expansion = "~/.local/bin/%"; };
          gcont = { position = "anywhere"; setCursor = true; expansion = "~/.local/containers/%"; };
        ####################
        # CURL SHENANIGANS #
        ####################
          ## CHEAT.SH
            cht = { setCursor = true; expansion = "curl cht.sh/%"; };
            cheat = { setCursor = true; expansion = "curl cht.sh/%"; };

          wttr = "curl wttr.in";

          gIPv4-way = "bash -c 'curl icanhazip.com | tee >(wl-copy)'";
          gIPv4-x11 = "bash -c 'curl icanhazip.com | xclip -i -selection clipboard'";

        #################
        # GIT SHORTCUTS #
        #################
          g = "git";
          gst = "git status";
          glg = "git log --graph --oneline --all";
          gco = "git checkout";
          gb = "git branch";
          gba = "git branch -a";
          gc = "git commit";
          gca = "git commit -a";
          gcp = "git cherry-pick";
          gp = "git pull";
          gph = "git push";
          ga = "git add";
          gau = "git add -u";
          gaa = "git add -all";
          gcl = "git clone";

          gd = "git diff";
          gdc = "git diff --cached";
          gdt = "git difftool";

        #############
        # SYSTEMCTL #
        #############
          scu = "systemctl --user";
          ssc = "sudo systemctl";

          scust = "systemctl --user status";
          sscst = "sudo systemctl status";

          scus = "systemctl --user stop";
          sscs = "sudo systemctl stop";

          scuen = "systemctl --user enable --now";
          sscen = "sudo systemctl enable --now";

          scur = "systemctl --user restart";
          sscr = "sudo systemctl restart";

          scudr = "systemctl --user daemon-reload";
          sscdr = "sudo systemctl daemon-reload";

          scud = "systemctl --user disable";
          sscd = "sudo systemctl disable";

          scuS = "systemctl --user start";
          sscS = "sudo systemctl start";

          scutr = "systemctl --user try-restart";
          ssctr = "sudo systemctl try-restart";

          scue = "systemctl --user edit --runtime";
          ssce = "sudo systemctl edit --runtime";

          scuf = "systemctl --user --failed";
          sscf = "sudo systemctl --failed"; 


        #####################
        # GENERAL SHORTCUTS #
        #####################
          c = "clear";
          del = "trash";
          rm = "rm -Iv";
          ls = "eza --group-directories-first --icons --color-scale all";
          suvi = "sudoedit";
          yay = "nix search nixpkgs";
          pass = "gopass";
          fpk = "flatpak";
      };
      shellAliases = {
        cb = "flatpak run app.getclipboard.Clipboard";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };
    };
  };
}
