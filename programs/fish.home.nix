{pkgs,...}:{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = /*sh*/ ''
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
        smt-cp = /*fish*/ ''
          set -l api_endpoint "https://api.groq.com/openai/v1/chat/completions"
          set -l api_key "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"
          set -l model "llama-3.3-70b-versatile"
          set -l num_recent_commands 5
          set -l scrollback_lines 50


          # --- Tests ---
          echo "--- Running llm_copy tests ---"

          # Test: API Key is set (basic sanity check)
          echo "Test: API Key is set"
          if not set -q api_key
            echo "  FAIL: api_key is not set!"
            return 1
          else
            echo "  PASS: api_key is set"
          end

          # Test: Get recent shell commands
          echo "Test: Get recent shell commands"
          set -l recent_commands_test (history --prefix ''' | tail -n $num_recent_commands)
          if not count $recent_commands_test > 0
            echo "  FAIL: Could not retrieve recent commands"
          else
            echo "  PASS: Retrieved recent commands:" $recent_commands_test
          end
          set -l recent_commands (string join '\n' $recent_commands_test)

          # Test: Get scrollback
          echo "Test: Get scrollback"
          set -l scrollback_test (history --show-time | tail -n $scrollback_lines)
          if not count $scrollback_test > 0
            echo "  FAIL: Could not retrieve scrollback"
          else
            echo "  PASS: Retrieved scrollback (first line):" (head -n 1 $scrollback_test)
          end
          set -l scrollback (string join '\n' $scrollback_test)

          # Test: Construct the prompt
          echo "Test: Construct the prompt"
          set -l prompt "Analyze the following terminal scrollback and recent commands to identify potential targets for copying (like file paths, URLs, specific values, error messages, etc.). Focus on items relevant to what the user might be doing based on the recent commands. Provide a newline-separated list of these potential copy targets.\n\nRecent Commands:\n$recent_commands\n\nScrollback:\n$scrollback"
          echo "  Prompt (first few lines):" (head -n 3 <<< "$prompt")

          # Test: Make the API call (output the curl command for debugging)
          echo "Test: Make the API call (check curl command)"
          set -l curl_command "curl -s -H 'Content-Type: application/json' -H 'Authorization: Bearer \$api_key' -d (printf '{\"model\": \"%s\", \"messages\": [{\"role\": \"user\", \"content\": \"%s\"}]}' \$model (string replace -a '\''' '\''' -- \"\$prompt\")) \$api_endpoint"
          echo "  Executing curl command:" $curl_command
          set -l response
          set response (curl -s \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $api_key" \
            -d (printf '{"model": "%s", "messages": [{"role": "user", "content": "%s"}]}' $model "$prompt") "$api_endpoint"

          echo "  LLM Response:" $response

          # Test: Extract the LLM's suggested copy targets
          echo "Test: Extract the LLM's suggested copy targets"
          if string length -- "\$response"
            set -l copy_targets (echo "\$response" | jq -r '.choices[0].message.content')
            echo "  Copy Targets:" \$copy_targets
          else
            echo "  LLM response was empty."
            set -l copy_targets ""
          end

          # Test: Handle empty or error responses from the LLM
          echo "Test: Handle empty LLM response"
          if not string length -- "$copy_targets"
            echo "  LLM did not suggest any copy targets."
          else
            echo "  LLM suggested targets. Proceeding to fzf."
            # Test: Pass the targets to fzf for selection
            echo "Test: Pass the targets to fzf"
            if command -sq fzf
              echo "$copy_targets" | fzf
              set -l selected_target $status # Capture fzf's exit status (0 for selection, 1 for no selection)
              echo "  fzf executed (status: $selected_target)"
              if string length -- "$selected_target"
                echo "  User selected: $selected_target"
                # Test: Copy to clipboard
                echo "Test: Copy to clipboard"
                if test -n "$WAYLAND_DISPLAY"
                  echo "$selected_target" | wl-copy
                  echo "  Copied to clipboard (Wayland): $selected_target"
                else if command -sq xclip
                  echo "$selected_target" | xclip -selection clipboard
                  echo "  Copied to clipboard (X11): $selected_target"
                else
                  echo "  Neither wl-copy nor xclip found."
                end
              else
                echo "  No target selected in fzf."
              end
            else
              echo "  fzf not found."
            end
          end

          echo "--- llm_copy tests finished ---"
          end
          # Create a key binding (optional)

          if not bind | grep llm_copy &>/dev/null
            bind \\cg llm_copy # Bind to Ctrl+g
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
            rev = "6fbcf9739a02844b99960c5ba5100911e4e657c9";
            sha256 = "sha256-/IscCr/KRkYV19EprvaVGo84G7T9y2A8QaFrKTnqRL4=";
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
        mutt = "neomutt";
        ###############
        # EDIT CONFIG #
        ###############
          ## WAYLAND
            rchpp = "nvim ~/.nixcfg/windowManagers/hm/hyprland.nix";
          ## X WINDOW MANGERS
            rsxh = "nvim ~/.nixcfg/.config/sxhkd/sxhkdrc";
          ## OTHER CONFIG ABBR
            dbx = "distrobox";
            rtri = "nvim ~/.nixcfg/.config/tridactyl/tridactylrc";
            rwb = "nvim ~/.nixcfg/.config/waybar/config";
          ## NIX SPECIFIC CONFIGS
            rhmc = "nvim ~/.nixcfg/users/meow/home.nix";
            rhmp = "cd ~/.nixcfg/programs/hm/";
            rnxf = "nvim ~/.nixcfg/flake.nix";
            rnxc = "nvim ~/.nixcfg/systems/meow/configuration.nix";
          ## REBUILD SYSTEM
            nfu = "nix flake update --flake ~/.nixcfg/";
            nxrb = "nh os switch ~/.nixcfg";
            hmrb = "nh home switch ~/.nixcfg/ -- --impure";
          ## GARBAGE COLLECTION
            nxgc = "sudo nix-collect-garbage -d";
            hmgc = "nix-collect-garbage -d";


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
          #pass = "gopass";
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
