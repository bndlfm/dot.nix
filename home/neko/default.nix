{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.stateVersion = "23.11";
  home.username = "neko";
  home.homeDirectory = "/home/neko";

  news.display = "silent";

  imports = [
    ../../cachix.nix
    ##############
    # CONTAINERS #
    ##############
    ../../containers/gluetun.home.nix
    ../../containers/homeassistant.home.nix

    ###########
    # MODULES #
    ###########
    #../../components/openComposite.home.nix # WiVRn
    ../../components/music.home.nix
    #FIX: ../../components/notes.home.nix

    ############
    # PROGRAMS #
    ############
    ../../programs/programs.home.nix
    ../../programs/email.home.nix
    ../../programs/shell
    ../../programs/twitch.home.nix

    ../../programs/firefox.home.nix
    ../../programs/git.home.nix
    ../../programs/neovim.home.nix
    ../../programs/password-store.home.nix
    ../../programs/ranger.home.nix
    ../../programs/rofi.home.nix
    ../../programs/yazi.home.nix

    ###########
    # SECRETS #
    ###########
    inputs.sops-nix.homeManagerModules.sops
    ../../sops/sops.home.nix

    ############
    # SERVICES #
    ############
    ../../services/espanso.home.nix
    ../../services/services.home.nix

    ###########
    # SPOTIFY #
    ###########
    inputs.spicetify-nix.homeManagerModules.default

    ###################
    # WINDOW MANAGERS #
    ###################
    #./programs/gnome-shell.home.nix
    ../../components/wm/hyprland.home.nix
    ../../components/wm/niri.home.nix
  ];

  ##########################
  # NIX / NIXPKGS SETTINGS #
  ##########################
  nix.package = pkgs.nix;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        ## NIXARR
        "dotnet-combined"
        "dotnet-core-combined"
        "dotnet-runtime-7.0.20"
        "dotnet-runtime-wrapped-7.0.20"
        "dotnet-wrapped-combined"
        "dotnet-sdk-6.0.428"
        "dotnet-sdk-wrapped-6.0.428"
        "dotnet-sdk-7.0.410"
        "dotnet-sdk-wrapped-7.0.410"
      ];
    };
    overlays = [ inputs.nur.overlays.default ];
  };

  ######################
  # FLATPAK / PACKAGES #
  ######################
  services = {
    flatpak = {
      enable = true;
      packages = [
        "com.google.EarthPro"
        "com.github.tchx84.Flatseal"
        "org.jdownloader.JDownloader"
      ];
      uninstallUnmanaged = true;
      update = {
        auto = {
          enable = true;
          onCalendar = "weekly";
        };
        onActivation = true;
      };
    };
  };

  home = {
    packages =
      with pkgs;
      let
        patched = [
          #inputs.deejavu.packages.x86_64-linux.default
          darktable
        ];

        ai = [
          #_open-claude-cowork
          antigravity-fhs
          code-cursor-fhs
          vscode-fhs
          windsurf

          #codex
          gemini-cli

          opencode
          #inputs.llama-cpp_ik.packages.x86_64-linux.cuda
          warp-terminal

          ## OPEN CLAW PKGS
          _openclaw
          _gifgrep
          _bird
          _blogwatcher
          _goplaces
          _mcporter
          _songsee
          _summarize
          _sag
          _nano-pdf
          _camsnap
          _gogcli
          _mcp-arr
          _clawdhub
          himalaya
          tmux
          openai-whisper
          uv

          sillytavern
        ];

        apple = [
          uxplay
        ];

        browsers = [
          #firefox-devedition: programs/hm/firefox.nix
          chromium
          google-chrome
          tor-browser
          qutebrowser
        ];

        cli = [
          age
          bat
          cachix
          chafa
          duf
          eza
          fd
          ffmpeg-full
          file
          fzf
          gnugrep
          gopass
          grex
          jq
          libnotify
          libqalculate
          nix-index
          (pkgs.pass.withExtensions (exts: [ exts.pass-otp ]))
          p7zip
          ripgrep
          sd
          silver-searcher
          sops
          unrar
          unzip
          usbutils
          wget
          wireguard-tools
          dragon-drop
          yt-dlp
        ];

        daemons = [
          yams
        ];

        editing = [
          gimp
          libreoffice-qt
        ];

        gaming = [
          airshipper # Veloren (Cube World)
          crawlTiles
          glfw3-minecraft
          #inputs.openmw-vr.packages.x86_64-linux.default

          # DECOMP
          sm64coopdx
          #shipwright # Ocarina of Time
          _2ship2harkinian # Majora's Mask

          # EMULATION
          shadps4

          # RHYTHM GAMES
          clonehero

          # GAMING UTILITIES
          # LAUNCHERS
          _gamma-launcher
          heroic
          pkgs.bndlfm.hydralauncher
          #itch
          lutris
          prismlauncher
          runelite

          # MODDING
          _beatSaberModManager
          sidequest

          # MISC
          mangohud
          protontricks
          protonup-ng
          steamtinkerlaunch
        ];

        media = [
          calibre
          freetube
          mpv
          # spotify: ~/.nixcfg/theme/spicetify.nix
        ];

        notes = [
          obsidian
        ];

        osint = [
        ];

        programming = [
          #
          # DOTNET
          #-------
          dotnetCorePackages.dotnet_10.sdk
          dotnetCorePackages.dotnet_10.runtime

          #
          # GIT TOOLS
          #----------
          git
          git-filter-repo
          git-lfs
          git-credential-manager
          git-credential-gopass

          #
          # PYTHON
          #-------
          (python3.withPackages (
            pkgs: with pkgs; [
              llama-cpp
              pynvim
              ueberzug
            ]
          ))

          #
          # NIX DEV TOOLS
          #---------------
          direnv
          nix-prefetch
          nix-inspect

          #
          # OTHER DEV TOOLS
          #----------------
          code-cursor-fhs
          godot_4
          godot_4-export-templates-bin
          meld
          zenity
        ];

        social = [
          vesktop
          discord
          signal-desktop
          hexchat
          telegram-desktop
        ];

        system = [
          openrgb

          # Plasma/QT
          qt6Packages.qt6ct
          qt6Packages.qtstyleplugin-kvantum
          # Wine/Proton
          wineWowPackages.stable
          winetricks
        ];

        theming = {
          fonts = [
            rictydiminished-with-firacode
            font-awesome
            gyre-fonts
            noto-fonts-emoji-blob-bin
          ];

          nerdFonts = with pkgs.nerd-fonts; [
            caskaydia-cove
            caskaydia-mono
            d2coding
            inconsolata
            inconsolata-lgc
            inconsolata-go
            iosevka-term
            sauce-code-pro
            terminess-ttf
          ];

          other = [
            base16-schemes
            ocs-url
            volantes-cursors
          ];
        };

        tui = [
          # PROGRAMMING
          lazygit
          # SYSTEM MONITORS
          btop
          iotop
          nvtopPackages.nvidia
          ## FILE MANAGERS AND UTILITIES
          highlight
          page
          pulsemixer
          ncdu # like dir stat but terminal
          ranger
          tdf # pretty pdf reader (zathura alternative)
        ];

        utilities = {
          wayland = [
            #_azote
            gammastep
            nwg-look
            waybar
            wttrbar
            wlr-randr
            wl-clipboard
            wl-clipboard-x11
            wl-clip-persist
            wl-gammactl
          ];

          xorg = [
            dunst
            eww
            jgmenu
            weather-icons
            nitrogen
            scrot
            sxhkd
            tdrop
            xbindkeys
            xorg.xkill
            xorg.xhost
          ];

          other = [
            appimage-run
            clipboard-jh
            copyq
            deskflow
            gnome-tweaks
            google-drive-ocamlfuse
            gparted
            grc
            keymapp
            nicotine-plus
            nix-prefetch
            pavucontrol
            qbittorrent
            qdirstat
            rofi
            zathura
            zsa-udev-rules
          ];
        };

        virtualization = [
          #NOTE: CHECK LATER FOR FIX (substituteAll)
          #nur.repos.ataraxiasjel.waydroid-script

          _waydroid-hide-desktop-entries
          ### CONTAINER
          boxbuddy
          podman
          podman-compose
          virt-manager
        ];

        misc = [
          speechd
        ];

      in
      [ ]
      ++ patched
      ++ ai
      ++ apple
      ++ browsers
      ++ cli
      ++ daemons
      ++ editing
      ++ gaming
      ++ media
      ++ notes
      ++ osint
      ++ programming
      ++ social
      ++ system
      ++ (theming.fonts ++ theming.nerdFonts ++ theming.other)
      ++ tui
      ++ (utilities.wayland ++ utilities.xorg ++ utilities.other)
      ++ virtualization
      ++ misc;

    ## (HM) ENVIRONMENT VARIABLES ##
    sessionVariables = {
      ## SECRETS
      ANTHROPIC_API_KEY = "$(cat ${config.sops.secrets."ai_keys/ANTHROPIC_API_KEY".path})";
      COMPOSIO_API_KEY = "$(cat ${config.sops.secrets."ai_keys/COMPOSIO_API_KEY".path})";
      GEMINI_SECRET_KEY = "$(cat ${config.sops.secrets."ai_keys/GEMINI_SECRET_KEY".path})";
      GROQ_SECRET_KEY = "$(cat ${config.sops.secrets."ai_keys/GROQ_SECRET_KEY".path})";
      HUGGINGFACE_API_KEY = "$(cat ${config.sops.secrets."ai_keys/HUGGINGFACE_API_KEY".path})";
      HUGGINGFACE_PASSWD = "$(cat ${config.sops.secrets."ai_keys/HUGGINGFACE_PASSWD".path})";

      DUCKDNS_TOKEN = "$(cat ${config.sops.secrets."internet/DUCKDNS_TOKEN".path})";
      GMAIL_APP_PASS = "$(cat ${config.sops.secrets."internet/GMAIL_APP_PASS".path})";
      TWITCH_IRC_OAUTH = "$(cat ${config.sops.secrets."internet/TWITCH_IRC_OAUTH".path})";
      OBSIDIAN_REST_API_KEY = "$(cat ${config.sops.secrets."local/OBSIDIAN_REST_API_KEY".path})";

      CLAWDBOT_DISCORD_TOKEN = "$(cat ${config.sops.secrets."discord/clawdbot".path})";
      CLAWDBOT_GATEWAY_TOKEN = "$(cat ${config.sops.secrets."local/CLAWDBOT_GATEWAY_TOKEN".path})";
      ## EDITOR
      EDITOR = "nvim";
      SUDOEDITOR = "nvim";
      VISUAL = "nvim";
      ## GPU
      PROTON_ENABLE_NVAPI = 1;
      PROTON_HIDE_NVIDIA_GPU = 0;
      VKD3D_CONFIG = "dxr";
      ## NIX
      NIXPKGS_ALLOW_UNFREE = 1;
      NIXOS_OZONE_WL = 1; # fixes electron wayland
      NH_FLAKE = "${builtins.getEnv "HOME"}/.nixcfg/"; # nix helper env var for flake location

      ## NIX PROFILES
      PATH = "$HOME/.local/state/nix/profiles/imperative/bin:$HOME/.local/state/nix/profiles/tools/bin:$PATH";

      ## PAGER
      PAGER = "nvim +Man!";
      MANPAGER = "nvim +Man!";

      ## QT STYLING
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_STYLE_OVERRIDE = "kvantum";

      ## ...
      ELECTRON_OZONE_PLATFORM_HINT = "wayland"; # fixes electron wayland
      DOCKER_HOST = "unix:///run/user/1000/docker.sock";
      GPG_TTY = "$(tty)";
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      MOZ_DBUS_REMOTE = "1"; # make firefox see dbus
    };

    ######### (HM) DOTFILES ########
    file = {
      ".aider.model.metadata.json" = {
        source = ../../.config/.aider.model.metadata.json;
      };
    };
  };

  xdg = {
    configFile = {
      "hypr" = {
        source = ../../.config/hypr;
        recursive = true;
      };
      "joshuto" = {
        source = ../../.config/joshuto;
        recursive = true;
      };
      ##"mimeapps../..list" = {
      ##  force = true;
      ##};
      "mutt" = {
        source = ../../.config/mutt;
        recursive = true;
      };
      "polybar" = {
        source = ../../.config/polybar;
        recursive = true;
      };
      "pulsemixer.cfg" = {
        source = ../../.config/pulsemixer.cfg;
        recursive = false;
      };
      "ranger" = {
        source = ../../.config/ranger;
        recursive = true;
      };
      "rofi" = {
        source = ../../.config/rofi;
        recursive = true;
      };
      "tridactyl" = {
        source = ../../.config/tridactyl;
        recursive = true;
      };
      "twt" = {
        source = ../../.config/twt;
        recursive = true;
      };
      "qutebrowser/config.py" = {
        source = ../../.config/qutebrowser/config.py;
      };
      "yazi" = {
        source = ../../.config/yazi;
        recursive = true;
      };
      "zathura" = {
        source = ../../.config/zathura;
        recursive = true;
      };
    };
  };

  systemd = {
    user = {
      services = {
        monado.environment = {
          STEAMVR_LH_ENABLE = "1";
          XRT_COMPOSITOR_COMPUTE = "1";
        };
      };
      targets.tray = {
        unitConfig = {
          Description = "Home Manager System Tray";
          Requires = [ "graphical-session-pre.target" ];
        };
      };
    };
  };

  specialisation = {
    familyTree.configuration = {
      home.packages = with pkgs; [
      ];
    };
  };
}
