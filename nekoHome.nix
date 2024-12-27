{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.stateVersion = "23.11";
  home.username = "neko";
  home.homeDirectory = "/home/neko";

  imports = [
    ./sops/sops.nix
    #./modules/hm/OpenComposite.nix

    ### PROGRAMS
    ./programs/hm/firefox.nix
    ./programs/hm/fish.nix
    ./programs/hm/git.nix
    ./programs/hm/gnome-shell.nix
    ./programs/hm/kitty.nix
    ./programs/hm/ncmpcpp.nix
    ./programs/hm/neovim.nix
    ./programs/hm/ranger.nix
    ./programs/hm/rofi.nix
    ./programs/hm/yazi.nix
    ./programs/hm/zellij.nix

    ./programs/hm/misc_programs.nix

    ### SERVICES
    ./services/hm/espanso.nix

    ./services/hm/misc_services.nix

    ### WINDOW MANAGERS
    ./windowManagers/hm/hyprland.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
      permittedInsecurePackages = [
        ### NIXARR
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
    overlays = [
      #(import ../../overlays/obsidian.nix)
    ];
  };
  home = {
    packages =
      with pkgs;
      let
        ai = [
          aider-chat
          upscayl
        ];

        apple = [
          uxplay
        ];

        browsers = [
          #firefox-devedition: programs/hm/firefox.nix
          firefoxpwa
          qutebrowser
          tor-browser
        ];

        cli = [
          age
          bat
          cachix
          chafa
          distrobox
          duf
          delta
          eza
          fd
          ffmpeg-full
          file
          fzf
          grex
          gnugrep
          gopass
          jq
          libnotify
          libqalculate
          nix-index
          ripgrep
          sd
          silver-searcher
          sops
          tesseract
          trashy
          unrar
          unzip
          usbutils
          wireguard-tools
          xdragon
          yt-dlp
          zip
          zoxide
        ];

        daemons = [
          inputs.deejavu.packages.x86_64-linux.default
          mpd-discord-rpc
          yams
        ];

        editing = [
          gimp
          libreoffice-qt
        ];

        gaming = [
          ### DECOMP
            sm64ex-coop
            shipwright # Ocarina of Time
            _2ship2harkinian # Majora's Mask
          ### EMULATION
            shadps4
          ### GAMING UTILITIES
            (callPackage ./pkgs/BeatSaberModManager/BeatSaberModManager.nix { })
            mangohud
            steamtinkerlaunch
          ### LAUNCHERS
            heroic
            lutris
            prismlauncher
          clonehero
          crawlTiles
          glfw-wayland-minecraft
          inputs.openmw-vr.packages.x86_64-linux.default
        ];

        media = [
          mpv
          ncmpcpp
          streamlink
          streamlink-twitch-gui-bin
        ];

        notes = [
          obsidian
        ];

        programming = [
          # Git tools
          git
          git-filter-repo
          git-lfs
          git-credential-manager
          git-credential-gopass
          # PYTHON
          (python3.withPackages (
            pkgs: with pkgs; [
              gguf
              llama-cpp
              pynvim
              ueberzug
            ]
          ))
          # FENNEL
          (pkgs.callPackage ./pkgs/antifennel.nix { })
          # OTHER DEV TOOLS
          godot_4
          godot_4-export-templates
          direnv
          nix-prefetch
          meld
        ];

        social = [
          discord
          hexchat
        ];

        system = [
          # Plasma/QT
          qt6Packages.qt6ct
          qt6Packages.qtstyleplugin-kvantum
          ksshaskpass
          # Wine
          winetricks
          wineWowPackages.stable
          protonup
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
          # System monitors
          btop
          iotop
          nvtopPackages.nvidia
          # File managers and utilities
          joshuto
          highlight
          page
          pulsemixer
          ranger
          tdf
        ];

        utilities = {
          wayland = [
            gammastep
            grimblast
            slurp
            nwg-look
            waybar
            wofi
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
            polybar
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
          ### CONTAINER
          boxbuddy
          podman
          podman-compose
          podman-desktop
          nur.repos.ataraxiasjel.waydroid-script
          virt-manager
        ];

        misc = [
          speechd
        ];

      in
      [ ]
      ++ ai
      ++ apple
      ++ browsers
      ++ cli
      ++ daemons
      ++ editing
      ++ gaming
      ++ media
      ++ notes
      ++ programming
      ++ social
      ++ system
      ++ (theming.fonts ++ theming.nerdFonts ++ theming.other)
      ++ tui
      ++ (utilities.wayland ++ utilities.xorg ++ utilities.other)
      ++ virtualization
      ++ misc;

    ### (HM) ENVIRONMENT VARIABLES ###
    sessionVariables = {
      ### API KEYS
      HUGGINGFACE_API_KEY = builtins.readFile "${config.sops.secrets.HUGGINGFACE_API_KEY.path}";
      OPENAI_API_KEY = builtins.readFile "${config.sops.secrets.OPENAI_API_KEY.path}";
      OBSIDIAN_REST_API_KEY = builtins.readFile "${config.sops.secrets.OBSIDIAN_REST_API_KEY.path}";

      ### DEFAULTS
      EDITOR = "nvim";
      GPG_TTY = "$(tty)";
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      PAGER = "nvim +Man!";
      MANPAGER = "nvim +Man!";
      SUDOEDITOR = "vim";
      VISUAL = "vim";

      ### GPU STUFF
      PROTON_ENABLE_NVAPI = "1";
      PROTON_HIDE_NVIDIA_GPU = "0";
      VKD3D_CONFIG = "dxr";
      VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

      ### MAKE FIREFOX SEE DBUS
      MOZ_DBUS_REMOTE = "1";

      ### NETWORK LOCATIONS
      DOCKER_HOST = "unix:///run/user/1000/docker.sock";
      #OLLAMA_HOST = "192.168.1.5";

      ### NIX: FIXES ELECTRON APPS
      NIXOS_OZONE_WL = "1";

      ### QT STYLING
      QT_QPA_PLATFORMTHEME = "qt6ct";
      #QT_STYLE_OVERRIDE = "kvantum";

      ### FIX... SOMETHING? TURNING OFF TO TEST
      #STEAM_DISABLE_BROWSER_SHUTDOWN_WORKAROUND=1;

      ### THEMING
      XCURSOR = "volantes-cursors";
      XCURSOR_SIZE = "24";
    };

    ######### (HM) DOTFILES ########
    file = {
      ".aider.model.metadata.json" = {
        source = ./.config/.aider.model.metadata.json;
      };
    };
  };

  xdg = {
    configFile = {
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
      #"niri" = {
      #  source = ./.config/niri;
      #  recursive = true;
      #};
      #"nvim" = {
      #  source = ./.config/nvim;
      #  recursive = true;
      #};
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
      "tridactyl" = {
        source = ./.config/tridactyl;
        recursive = true;
      };
      "qutebrowser/config.py" = {
        source = ./.config/qutebrowser/config.py;
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
  };

  specialisation = {
    gnome.configuration = {
      home.packages = with pkgs; [
        gnome-tweaks
      ];
    };

    familyTree.configuration = {
      home.packages = with pkgs; [
        ocrmypdf
      ];
    };
  };
}
