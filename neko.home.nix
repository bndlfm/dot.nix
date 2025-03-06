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
    /**************
    * MONADO (VR) *
    **************/
      #./modules/openComposite.home.nix

    /***********
    * PROGRAMS *
    ************/
      #./programs/email.home.nix
      ./programs/programs.home.nix
      ./programs/twitch.home.nix

      ./programs/shell.home.nix

      ./programs/firefox.home.nix
      ./programs/git.home.nix
      ./programs/kitty.home.nix
      ./programs/ncmpcpp.home.nix
      ./programs/neovim.home.nix
      ./programs/password-store.home.nix
      ./programs/ranger.home.nix
      ./programs/rofi.home.nix
      ./programs/yazi.home.nix
      ./programs/zellij.home.nix


    /**********
    * SECRETS *
    **********/
      inputs.sops-nix.homeManagerModules.sops
      ./sops/sops.nix


    /***********
    * SERVICES *
    ***********/
      ./services/espanso.home.nix
      ./services/services.home.nix


    /**********
    * SPOTIFY *
    **********/
      inputs.spicetify-nix.homeManagerModules.default
      ./theme/spicetify.nix


    /******************
    * WINDOW MANAGERS *
    ******************/
      #./programs/gnome-shell.home.nix

      ./windowManagers/bspwm.home.nix
      ./modules/home-manager/hyprland.home.mod.nix
      ./windowManagers/niri.home.nix
  ];

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
    overlays = [
      inputs.nur.overlays.default
    ];
  };

  _hyprland.enable = true;

  nix.package = pkgs.nix; # Required for Chaotic Nyx

  home =
    {
      packages =
        with pkgs;
        let
          ai =
            [
              aichat
              aider-chat
              _gsh
              upscayl
              warp-terminal
            ];

          apple =
            [
              uxplay
              rpiplay
            ];

          browsers =
            [
              #firefox-devedition: programs/hm/firefox.nix
              inputs.zen-browser.packages.x86_64-linux.twilight
              ladybird
              tor-browser
              qutebrowser
            ];

          cli =
            [
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
              (pkgs.pass.withExtensions (exts: [exts.pass-otp]))
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

          daemons =
            [
              inputs.deejavu.packages.x86_64-linux.default
              megasync
              mpd-discord-rpc
              yams
            ];

          editing =
            [
              gimp
              libreoffice-qt
            ];

          gaming =
            [
              airshipper
              crawlTiles
              _gamma-launcher
              glfw-wayland-minecraft
              inputs.openmw-vr.packages.x86_64-linux.default
              ## RHYTHM GAMES
                clonehero
              ## DECOMP
                sm64coopdx
                #shipwright # Ocarina of Time
                _2ship2harkinian # Majora's Mask
              ## EMULATION
                shadps4
              ## GAMING UTILITIES
                _beatSaberModManager
                mangohud
                protontricks
                steamtinkerlaunch
              ## LAUNCHERS
                heroic
                itch
                lutris
                prismlauncher
            ];

          media =
            [
              freetube
              mpv
              ncmpcpp
            ];

          notes =
            [
              obsidian
            ];

          programming =
            [
              ## GIT TOOLS
                git
                git-filter-repo
                git-lfs
                git-credential-manager
                git-credential-gopass
              ## PYTHON
                (python3.withPackages (
                  pkgs: with pkgs; [
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

          social =
            [
              discord
              vesktop
              hexchat
            ];

          system =
            [
              # Plasma/QT
                qt6Packages.qt6ct
                qt6Packages.qtstyleplugin-kvantum
                kdePackages.ksshaskpass
              # Wine/Proton
                winetricks
                wineWowPackages.stable
                protonup
            ];

          theming =
            {
              fonts =
                [
                  rictydiminished-with-firacode
                  font-awesome
                  gyre-fonts
                  noto-fonts-emoji-blob-bin
                ];

              nerdFonts =
                with pkgs.nerd-fonts;
                [
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

              other =
                [
                  base16-schemes
                  ocs-url
                  volantes-cursors
                ];
            };

          tui =
            [
              inputs.isd.packages.${pkgs.system}.isd
              ## PROGRAMMING
                fx #json viewer
                harlequin # sql ide
                lazygit
                posting # api client
              ## SYSTEM MONITORS
                btop
                iotop
                nvtopPackages.nvidia
              ## FILE MANAGERS AND UTILITIES
                highlight
                page
                pulsemixer
                ncdu
                ranger
                tdf
            ];

          utilities =
            {
              wayland = [
                _azote
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

          virtualization =
            [
              nur.repos.ataraxiasjel.waydroid-script
              _waydroid-hide-desktop-entries
              ### CONTAINER
                boxbuddy
                podman
                podman-compose
                virt-manager
            ];

          misc =
            [
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
      ANTHROPIC_API_KEY = builtins.readFile "${config.sops.secrets.ANTHROPIC_API_KEY.path}";
      HUGGINGFACE_API_KEY = builtins.readFile "${config.sops.secrets.HUGGINGFACE_API_KEY.path}";
      GROQ_SECRET_KEY = builtins.readFile "${config.sops.secrets.GROQ_SECRET_KEY.path}";
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
      QT_STYLE_OVERRIDE = "kvantum";

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

  xdg =
    {
      configFile =
        {
          "hypr" =
            {
              source = ./.config/hypr;
              recursive = true;
            };
          "joshuto" =
            {
              source = ./.config/joshuto;
              recursive = true;
            };
          "mutt" =
            {
              source = ./.config/mutt;
              recursive = true;
            };
        #"nvim" = {
        #  source = ./.config/nvim;
        #  recursive = true;
        #};
          "polybar" =
            {
              source = ./.config/polybar;
            recursive = true;
            };
          "pulsemixer.cfg" =
            {
              source = ./.config/pulsemixer.cfg;
              recursive = false;
            };
          "ranger" =
            {
              source = ./.config/ranger;
              recursive = true;
            };
          "rofi" =
            {
              source = ./.config/rofi;
              recursive = true;
            };
          "tridactyl" =
            {
              source = ./.config/tridactyl;
              recursive = true;
            };
          "twt" =
            {
              source = ./.config/twt;
              recursive = true;
            };
          "qutebrowser/config.py" =
            {
              source = ./.config/qutebrowser/config.py;
            };
          "waybar" =
            {
              source = ./.config/waybar;
              recursive = true;
            };
          "yazi" =
            {
              source = ./.config/yazi;
              recursive = true;
            };
          "zathura" =
            {
              source = ./.config/zathura;
              recursive = true;
            };
        };
    };

  systemd.user.targets.tray = {
      Unit = {
          Description = "Home Manager System Tray";
          Requires = [ "graphical-session-pre.target" ];
      };
  };

  specialisation = {
    familyTree.configuration = {
      home.packages = with pkgs; [
        ocrmypdf
      ];
    };
  };
}
