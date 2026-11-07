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
    ../../modules/home-manager/hermes.home.nix
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

  # --- Home Packages --- {{{
  home = {
    packages =
      with pkgs;
      let
        chromium-cdp = chromium.override {
          commandLineArgs = [
            "--remote-debugging-address=127.0.0.1"
            "--remote-debugging-port=9222"
            "--remote-allow-origins=http://127.0.0.1:9222"
            "--remote-allow-origins=http://localhost:9222"
            "--user-data-dir=${config.home.homeDirectory}/.config/chromium-cdp"
          ];
        };

        # --- Categories --- {{{
        patched = [
          #inputs.deejavu.packages.x86_64-linux.default
        ];

        ai = [
          chatgpt-bin
          sillytavern
          warp-terminal
        ];

        apple = [
        ];

        browsers = [
          #zen browser: ./programs/zen-browser.home.nix
          tor-browser
          chromium-cdp
        ];

        cli = [
          age
          bat
          chafa
          ddgr
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
          #gimp
          inkscape
          libreoffice-qt
        ];

        gaming = [
          _bsdrx
          crawlTiles
          glfw3-minecraft
          oversteer
          inputs.optiscaler-client.packages.${pkgs.system}.default
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
          _vr-cyberdeck
          jackify
          heroic
          lutris
          prismlauncher

          # MISC
          moonlight-qt
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
          #antigravity-ide-fhs

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
          android-tools
          meld

          #
          # NODEJS
          #-------
          nodejs
          yarn
        ];

        social = [
          dino
          signal-desktop
          telegram-desktop
        ];

        system = [
          #eddie - powershell 7.0 broken as of oct 21
          file-roller
          nwg-look
          openrgb
          scrcpy

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
          #nvtopPackages.nvidia
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
            cabextract
            copyq
            easyeffects
            jack2
            qpwgraph
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
