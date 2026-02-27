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

    ###########
    # MODULES #
    ###########
    ../../blocks/music.home.nix
    #FIX: ../../blocks/notes.home.nix

    ############
    # PROGRAMS #
    ############
    ../../programs/programs.home.nix
    ../../programs/email.home.nix
    ../../programs/shell
    ../../blocks/shell/zellij.home.nix
    ../../programs/twitch.home.nix

    ../../programs/firefox.home.nix
    ../../programs/git.home.nix
    ../../programs/neovim.home.nix
    ../../programs/password-store.home.nix
    ../../programs/ranger.home.nix
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
    ../../programs/gnome-shell.home.nix
    ../../blocks/wm/hyprland.home.nix
    ../../blocks/wm/niri.home.nix
  ];

  ##########################
  # NIX / NIXPKGS SETTINGS #
  ##########################
  nix.package = pkgs.nix;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      cudaSupport = true;
      permittedInsecurePackages = [
        "ventoy-qt5-1.1.10"
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
        ];

        ai = [
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
          chromium

          sillytavern
          _xhisper-local
          _screenpipe
        ];

        apple = [
          uxplay
        ];

        browsers = [
          #firefox-devedition: programs/hm/firefox.nix
          tor-browser
          qutebrowser
        ];

        cli = [
          age
          bat
          chafa
          duf
          eza
          fd
          ffmpeg-full
          fzf
          gopass
          gpu-screen-recorder
          jq
          libnotify
          libqalculate
          nix-index
          (pkgs.pass.withExtensions (exts: [ exts.pass-otp ]))
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
          #airshipper # Veloren (Cube World)
          crawlTiles
          glfw3-minecraft
          #inputs.openmw-vr.packages.x86_64-linux.default

          # DECOMP
          #sm64coopdx
          #shipwright # Ocarina of Time
          #_2ship2harkinian # Majora's Mask

          # EMULATION
          #shadps4

          # RHYTHM GAMES
          clonehero

          # GAMING UTILITIES
          # LAUNCHERS
          _gamma-launcher
          heroic
          lutris
          prismlauncher

          # MODDING
          #_beatSaberModManager

          # MISC
          mangohud
          protontricks
          steamtinkerlaunch
        ];

        media = [
          calibre
          plezy
          mpv
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
          #dotnetCorePackages.dotnet_10.sdk
          #dotnetCorePackages.dotnet_10.runtime

          #
          # GIT TOOLS
          #----------
          git
          git-lfs
          git-credential-manager
          git-credential-gopass

          #
          # PYTHON
          #-------
          (python3.withPackages (pkgs: with pkgs; [ ]))

          #
          # NIX DEV TOOLS
          #---------------
          direnv
          nix-prefetch
          nix-inspect

          #
          # OTHER DEV TOOLS
          #----------------
          meld
        ];

        social = [
          vesktop
          discord
          signal-desktop
          hexchat
          telegram-desktop
        ];

        system = [
          nwg-look
          openrgb
          file-roller

          # Plasma/QT
          qt6Packages.qt6ct

          ventoy-full-qt
          # Wine/Proton
          wineWow64Packages.stable
          winetricks
        ];

        theming = {
          fonts = [
            rictydiminished-with-firacode
            font-awesome
            gyre-fonts
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-emoji-blob-bin
          ];

          nerdFonts = with pkgs.nerd-fonts; [
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
          page
          pulsemixer
          ncdu # like dir stat but terminal
          ranger
        ];

        utilities = {
          wayland = [
            wl-clipboard
            wl-clipboard-x11
            wl-clip-persist
            gammastep
            wl-gammactl
            wttrbar
            wlr-randr
          ];

          xorg = [
            weather-icons
            xbindkeys
            xkill
            xhost
          ];

          other = [
            appimage-run
            copyq
            gnome-tweaks
            google-drive-ocamlfuse
            gparted
            grc
            keymapp
            nicotine-plus
            nix-prefetch
            qbittorrent
            qdirstat
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
