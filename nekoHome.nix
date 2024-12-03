{ config, pkgs, inputs, ... }: {
  home.stateVersion = "23.11";
  home.username = "neko";
  home.homeDirectory = "/home/neko";

  imports = [
    ./sops/sops.nix
    #./modules/hm/OpenComposite.nix # MONADO

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
        ### NIXARR
          "dotnet-runtime-wrapped-7.0.20"
          "dotnet-sdk-wrapped-7.0.410"
          "dotnet-runtime-7.0.20"
          "dotnet-core-combined"
          "dotnet-sdk-7.0.410"
          "dotnet-sdk-6.0.428"
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
        noto-fonts-emoji-blob-bin
        nerd-fonts.caskaydia-cove
        nerd-fonts.caskaydia-mono
        nerd-fonts.d2coding
        nerd-fonts.inconsolata
        nerd-fonts.inconsolata-lgc
        nerd-fonts.inconsolata-go
        nerd-fonts.iosevka-term
        nerd-fonts.sauce-code-pro
        nerd-fonts.terminess-ttf
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
      podman-desktop


    ### MISC PACKAGES
      speechd
  ];


  ######### (HM) ENVIRONMENT VARIABLES #########
  home.sessionVariables = {
    ### API KEYS
        OPENAI_API_KEY = builtins.readFile "${config.sops.secrets.OPENAI_API_KEY.path}";
        OBSIDIAN_REST_API_KEY = builtins.readFile "${config.sops.secrets.OBSIDIAN_REST_API_KEY.path}";

    ### DEFAULTS
        EDITOR  = "nvim";
        GPG_TTY ="$(tty)";
        _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd";
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
        MOZ_DBUS_REMOTE="1";

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
