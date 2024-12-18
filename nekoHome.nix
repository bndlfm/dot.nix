{ config, pkgs, inputs, ... }: {
  home.stateVersion = "23.11";
  home.username = "neko";
  home.homeDirectory = "/home/neko";

  imports = [
    ./sops/sops.nix

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
#      ./services/hm/espanso.nix

      ./services/hm/misc_services.nix

    ### WINDOW MANAGERS
      ./windowManagers/hm/hyprland.nix
      ./windowManagers/hm/sway.nix
      ./windowManagers/hm/bspwm.nix
    ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz")
          { inherit pkgs; };
        };
      permittedInsecurePackages = [
        "fluffychat-linux-1.22.1"
        "olm-3.2.16"
        ];
      };
    overlays = [
      #(import ../../overlays/obsidian.nix)
      ];
    };

  home.packages = with pkgs; [
    ### AI
      aider-chat
      upscayl


    ### APPLE (FUCK YOU!)
      uxplay


    ### BROWSERS
      firefoxpwa
      qutebrowser
      tor-browser


    ### CLI
      age
      bat
      cachix
      chafa
      distrobox
      duf
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
      silver-searcher #ag
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


    ### DAEMONS
      mpd-discord-rpc
      yams


    ### EDITING TOOLS
      gimp
      libreoffice-qt


    ### GAMES
        ### EMULATION
          shadps4
      (pkgs.callPackage ./pkgs/BeatSaberModManager/BeatSaberModManager.nix {})
      crawlTiles
      glfw-wayland-minecraft
      heroic
      lutris
      prismlauncher
      steamtinkerlaunch


    ### MEDIA
      mpv
      ncmpcpp
      streamlink-twitch-gui-bin
        streamlink


    ### NOTES
      obsidian


    ### PROGRAMMING
      ### GIT
        git
        git-filter-repo
        git-lfs
        git-credential-manager
        git-credential-gopass
      ## PYTHON
        (python3.withPackages (pkgs: with pkgs; [
          gguf
          llama-cpp
          pynvim
          ueberzug
          ]))
      ## FENNEL
        #(pkgs.callPackage ./pkgs/antifennel.nix {})
      godot_4
      godot_4-export-templates
      direnv
      dotnet-sdk_7
      meld


    ### SOCIAL
      discord
      hexchat

    ### SYSTEM
      ### Plasma5-6/QT5-6
        qt6Packages.qt6ct
        qt6Packages.qtstyleplugin-kvantum
        ksshaskpass
      podman
      podman-compose
      protonup
      winetricks
      wineWowPackages.stable


    ### THEMING
      ### FONTS
        rictydiminished-with-firacode
        font-awesome
        gyre-fonts
        (pkgs.nerdfonts.override {
          fonts = [
            "Inconsolata"
            #"SauceCodePro"
            "IosevkaTerm"
            ];
          }
        )
        noto-fonts-emoji-blob-bin
      base16-schemes
      ocs-url
      volantes-cursors


    ### TUI
      ### TOP-LIKES
        btop
        iotop
        nvtopPackages.nvidia
      joshuto
        highlight
      page
      pulsemixer
      ranger
      tdf


    ### UTILITIES
      ### WAYLAND SPECIFIC
        gammastep
        grimblast
        slurp
        nwg-look
        waybar
        #waybar-mpris
        wofi
        wttrbar
        wlr-randr
        wl-clipboard
        wl-clipboard-x11
        wl-clip-persist
        wl-gammactl
      ### XORG TOOLS
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
        #xclip
        xorg.xkill
        xorg.xhost
      appimage-run
      clipboard-jh
      copyq
      gnome-tweaks
      google-drive-ocamlfuse
      gparted
      grc
      keymapp # For ErgoDox
        zsa-udev-rules
      nicotine-plus
      pavucontrol
      qbittorrent
      qdirstat
      rofi
      virt-manager
      zathura


    ### VIRTUALISATION
      virt-manager


    ### MISC PACKAGES
      speechd
  ];


  ######### (HM) ENVIRONMENT VARIABLES #########
  home.sessionVariables = {
    DOCKER_HOST = "unix:///run/user/1000/docker.sock";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_7}";
    EDITOR  = "nvim";
    GPG_TTY ="$(tty)";
    _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd";
    PAGER = "nvim +Man!";
    MANPAGER = "nvim +Man!";
    MOZ_DBUS_REMOTE="1";
    NIXOS_OZONE_WL = "1";
    OBSIDIAN_REST_API_KEY = "3944368ac24bde98e46ee2d5b6425ce57d03399d799cdbc2453e10b8c407618a"; # local key, not active
    OLLAMA_HOST = "192.168.1.5";
    OPENAI_API_KEY = builtins.readFile "${config.sops.secrets.OPENAI_API_KEY.path}";
    #QT_QPA_PLATFORMTHEME = "qt6ct";
    #QT_STYLE_OVERRIDE = "kvantum";
    STEAM_DISABLE_BROWSER_SHUTDOWN_WORKAROUND=1;
    SUDOEDITOR = "vim";
    VISUAL = "vim";
    XCURSOR = "volantes-cursors";
    XCURSOR_SIZE = "24";
    ### GPU STUFF
      PROTON_ENABLE_NVAPI = "1";
      PROTON_HIDE_NVIDIA_GPU = "0";
      VKD3D_CONFIG = "dxr";
      VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  };

  ######### (HM) DOTFILES ########
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
        #recursive = true;
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
