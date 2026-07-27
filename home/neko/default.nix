{
  config,
  inputs,
  pkgs,
  ...
}:
{
  # --- Home Settings --- {{{
  home.stateVersion = "23.11";
  home.username = "neko";
  home.homeDirectory = "/home/neko";

  news.display = "silent";

  imports = [
  ];
  # }}}

  # --- Nix / Nixpkgs --- {{{
  nix.package = pkgs.nix;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      cudaSupport = true;
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.10"
        "pnpm-10.29.2"
        "electron-40.10.5"
        "openclaw-2026.6.33"
      ];
    };
    overlays = [ inputs.nur.overlays.default ];
  };
  # }}}

  # --- Flatpak / Services --- {{{
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
  # }}}

  # --- Home Packages --- {{{
  home = {
    packages =
      with pkgs;
      let
        # --- Categories --- {{{
        patched = [
          #inputs.deejavu.packages.x86_64-linux.default
        ];

        ai = [
          openclaw
          sillytavern
          warp-terminal
        ];

        apple = [
          uxplay
        ];

        browsers = [
          #zen browser: ./programs/zen-browser.home.nix
          tor-browser
          chromium
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
          # yams
        ];

        editing = [
          gimp
          inkscape
          libreoffice-qt
        ];

        gaming = [
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

          # LAUNCHERS
          _gamma-launcher
          heroic
          #lutris
          prismlauncher

          # MISC
          mangohud
          protontricks
          steamtinkerlaunch
        ];

        media = [
          #calibre
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
          # AGENTS
          #--------
          #
          gemini-cli
          claude-code

          #
          # GIT TOOLS
          #----------
          git
          git-lfs
          git-credential-manager
          git-credential-gopass

          #
          # IDE
          #-----
          antigravity-ide-fhs
          code-cursor-fhs

          #
          # PYTHON
          #-------
          (python3.withPackages (
            pkgs: with pkgs; [
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
          meld
        ];

        social = [
          discord
          dino
          signal-desktop
          hexchat
          telegram-desktop
        ];

        system = [
          nwg-look
          openrgb
          file-roller

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
            fonts._ioskeley-mono-NF
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
            _volantes-hyprcursor
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
            deskflow
            gammastep
            wl-clipboard
            wl-clipboard-x11
            wl-gammactl
            wttrbar
            wlr-randr
          ];

          xorg = [
            weather-icons
            xkill
            xhost
          ];

          other = [
            appimage-run
            copyq
            easyeffects
            gnome-tweaks
            google-drive-ocamlfuse
            gparted
            grc
            keymapp
            nicotine-plus
            nix-prefetch
            qbittorrent
            qdirstat
            vicinae
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
        # }}}

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

    # --- Session Variables --- {{{
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

      ## ...
      ELECTRON_OZONE_PLATFORM_HINT = "wayland"; # fixes electron wayland
      DOCKER_HOST = "unix:///run/user/1000/docker.sock";
      GPG_TTY = "$(tty)";
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      MOZ_DBUS_REMOTE = "1"; # make firefox see dbus
    };
    # }}}
  };
  # }}}

  # --- XDG --- {{{
  xdg = {
    configFile = {
      # "hypr" = {
      #   source = ../../.config/hypr;
      #   recursive = true;
      # };
      "joshuto" = {
        source = ../../.config/joshuto;
        recursive = true;
      };
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
      "zathura" = {
        source = ../../.config/zathura;
        recursive = true;
      };
    };
  };
  # }}}
}

# vim: foldmethod=marker foldmarker={{{,}}} foldlevel=1
