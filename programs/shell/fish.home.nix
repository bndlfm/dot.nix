{ pkgs, config, ...}:{
  home.packages = with pkgs; [
    meow
    bat
  ];

  programs = {
    /*************
    * FISH SHELL *
    *************/
    fish = {
      enable = true;
      interactiveShellInit = /*sh*/ ''
        set PATH $PATH /home/neko/.local/bin
        set pisces_only_insert_at_eol 1

        function fish_greeting --description "Prints To-do.md as Shell Greeting"
          #meow
          #bat ~/Notes/To-do/To-do.md --style=plain --no-paging
        end

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
            set -g FISH_AI_KEYMAP_1 'ctrl-x'
            bind -M insert ctrl-x _fish_ai_codify_or_explain
            set -g FISH_AI_KEYMAP_2 'ctrl-/'
            bind -M insert ctrl-/ _fish_ai_autocomplete_or_fix

            bind -M insert \cp up-or-search # fixes fish-ai keybind
            bind -M insert \cn down-or-search # fixes fish-ai keybind
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
        {
          name = "fisher";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "fisher";
            rev = "1f0dc2b4970da160605638cb0f157079660d6e04";
            sha256 = "sha256-pR5RKU+zIb7CS0Y6vjx2QIZ8Iu/3ojRfAcAdjCOxl1U=";
          };
        }
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
        { name = "fish-ai"; src = pkgs._fish-ai; }
        {
          name = "fish-fastdir";
          src = pkgs.fetchFromGitHub {
            owner = "danhper";
            repo = "fish-fastdir";
            rev = "dddc6c13b4afe271dd91ec004fdd199d3bbb1602";
            sha256 = "iu7zNO7yKVK2bhIIlj4UKHHqDaGe4q2tIdNgifxPev4=";
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
        ### APP ABBR ###
          fpk = "flatpak";
          mutt = "neomutt";
          vi = "nvim";
          vim = "nvim";

        ### EDIT CONFIG ###
          # other config abbr
            dbx = "distrobox";
            rtri = "nvim ~/.nixcfg/.config/tridactyl/tridactylrc";
            rwayb = "nvim ~/.nixcfg/.config/waybar/config";
            zni = "cd ~/.nixcfg";
          ## NIX SPECIFIC CONFIGS
            nxs = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
            nxc = "nixos-container";
            ## REBUILD SYSTEM
              nfu = "nix flake update --flake ~/.nixcfg/";
              nxrb = "nh os switch ~/.nixcfg";
              hmrb = "nh home switch ~/.nixcfg/ -b hmbackup -- --impure";
            ## GARBAGE COLLECTION
              nxgc = "sudo nix-collect-garbage -d";
              hmgc = "nix-collect-garbage -d";

        ### CURL SHENANIGANS ###
          #cheat.sh
            cht = { setCursor = true; expansion = "curl cht.sh/%"; };
            cheat = { setCursor = true; expansion = "curl cht.sh/%"; };
          #weather
            wttr = "curl wttr.in";
          #get ip
            gIPv4-way = "bash -c 'curl ipv4.icanhazip.com | tee >(wl-copy)'";
            gIPv6-way = "bash -c 'curl ipv6.icanhazip.com | tee >(wl-copy)'";
            gIPv4-x11 = "bash -c 'curl ipv4.icanhazip.com | xclip -i -selection clipboard'";
            gIPv6-x11 = "bash -c 'curl ipv6.icanhazip.com | xclip -i -selection clipboard'";

        ### GIT SHORTCUTS ###
          g = "git";
          gco = "git checkout";
          gcl = "git clone";
          gcp = "git cherry-pick";
          glg = "git log --graph --oneline --all";
          gst = "git status";
          #git branch
          gb = "git branch";
          gba = "git branch -a";
          #git commit
          gc = "git commit";
          gca = "git commit -a";
          gcm = { setCursor = true; expansion = "git commit -m '%'";};
          #git pull/push
          gp = "git pull";
          gph = "git push";
          #git add
          ga = "git add";
          gau = "git add -u";
          gaa = "git add -all";
          #git diff
          gd = "git diff";
          gdc = "git diff --cached";
          gdt = "git difftool";

        ### SYSTEMCTL ###
          #systemctl
            scu = "systemctl --user";
            ssc = "sudo systemctl";
          #systemctl status
            scust = "systemctl --user status";
            sscst = "sudo systemctl status";
          #systemctl stop
            scus = "systemctl --user stop";
            sscs = "sudo systemctl stop";
          #systemctl enable now
            scuen = "systemctl --user enable --now";
            sscen = "sudo systemctl enable --now";
          #systemctl restart
            scur = "systemctl --user restart";
            sscr = "sudo systemctl restart";
          #systemctl daemon reload
            scudr = "systemctl --user daemon-reload";
            sscdr = "sudo systemctl daemon-reload";
          #systemctl disable
            scud = "systemctl --user disable";
            sscd = "sudo systemctl disable";
          #systemctl start
            scuS = "systemctl --user start";
            sscS = "sudo systemctl start";
          #systemctl try-restart
            scutr = "systemctl --user try-restart";
            ssctr = "sudo systemctl try-restart";
          #systemctl edit runtime
            scue = "systemctl --user edit --runtime";
            ssce = "sudo systemctl edit --runtime";
          #systemctl failed
            scuf = "systemctl --user --failed";
            sscf = "sudo systemctl --failed";

        ### GENERAL SHORTCUTS ###
          c = "clear";
          del = "trash";
          rm = "rm -Iv";
          ls = "eza --group-directories-first --icons --color-scale all";
          suvi = "sudoedit";
          yay = "nix search nixpkgs";
      };
      shellAliases = {
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };
    };

  /*********************
  * SHELL INTEGRATIONS *
  *********************/
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
    eza = {
      enable = true;
      enableFishIntegration = true;
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    mcfly = {
      enable = false;
      enableFishIntegration = true;
    };
    navi = {
      enable = true;
      enableFishIntegration = true;
    };
    nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    oh-my-posh = {
      enable = true;
      enableFishIntegration = false;
    };
    pay-respects = {
      enable = true;
      enableFishIntegration = true;
    };
    yazi = {
      enable = true;
      enableFishIntegration = true;
    };
    zellij = {
      enable = false;
      enableFishIntegration = true;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
  services = {
    gpg-agent = {
      enableFishIntegration = true;
    };
  };

  sops.templates."fish-ai.ini" = {
    content = ''
      [fish-ai]
      configuration = google
      history = 10
      preview_pipe = True

      [google]
      provider = google
      api_key = ${config.sops.placeholder."ai_keys/GEMINI_SECRET_KEY"}
      model = gemini-3-flash-preview
    '';
  };

  xdg.configFile."fish-ai.ini".source =
    config.lib.file.mkOutOfStoreSymlink config.sops.templates."fish-ai.ini".path;

}
