{ pkgs, ... }: {
  imports = [
    #./modules/hmFlatpak.nix
    ../../programs/hmPrograms.nix
    ../../modules/hmServices.nix

    ../../programs/fish.nix
    ../../programs/kitty.nix
    ../../programs/ncmpcpp.nix
    ../../programs/neovim.nix
    ../../programs/yazi.nix

    ../../modules/windowManagers.nix
  ];

  home.stateVersion = "23.11";
  home.username = "neko";
  home.homeDirectory = "/home/neko";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz")
          { inherit pkgs; };
      };
      permittedInsecurePackages = [
        "nix-2.16.2"
        "googleearth-pro-7.3.4.8248"
      ];
    };
    overlays = [
      (import ../../overlays/overlays.nix)
    ];
  };

  home.packages = with pkgs; [

    #!!!! TEMP INSTALLS !!!!#
      maiko
      zellij

    ### AI
      upscayl

    ### BROWSER
      firefox-devedition
      qutebrowser

    ### CLI
      bat
      chafa
      eza
      fd
      ffmpeg-full
      file
      fzf
      gnugrep
      gopass
      jq
      libnotify
      libqalculate
      nix-index
      ripgrep
      silver-searcher
      trashy
      wireguard-tools
      xdragon
      yt-dlp
      zip
      zoxide

    ### TUI
      ### TOP-LIKES
        btop
        iotop
        nvtopPackages.nvidia
      ranger
      joshuto
        highlight
      page
      pulsemixer

    ### EDITING TOOLS
      gimp

    ### NOTES
      obsidian

    ### GAMES
      crawlTiles
      libreoffice-qt
      prismlauncher

    ### MEDIA
      mpd
      mpd-discord-rpc
      mpv
      ncmpcpp
      streamlink-twitch-gui-bin
        streamlink

    ### PROGRAMMING
      ### GIT
        git
        git-filter-repo
        git-lfs
        git-credential-gopass
      ## MERCURIAL
         mercurial
      codeium
      csharprepl
      direnv
      #dotnet-sdk_7
      dotnetCorePackages.sdk_8_0_2xx
      meld
      python3

    ### SOCIAL
      chatterino2
      discord
      ripcord

    ### SYSTEM
      ### Plasma5-6/QT5-6
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qt5ct
        qt6Packages.qt6ct
        qt6Packages.qtstyleplugin-kvantum
      podman
      podman-compose
      protonup
      winetricks
      wineWow64Packages.staging


    ### THEMING
      ### FONTS
        rictydiminished-with-firacode
        font-awesome
        gyre-fonts
        nerdfonts
        noto-fonts-emoji-blob-bin
      base16-schemes
      ocs-url
      volantes-cursors


    ### UTILITIES
      ### WAYLAND SPECIFIC
        ### SWAY TOOLS
          swaybg
          swayidle
          swaylock
          swaynotificationcenter
        ### HYPRLAND TOOLS
          hdrop
          hyprpaper
          hyprshot
        gammastep
        grimblast
        slurp
        nwg-look
        waybar
        #waybar-mpris
        wttrbar
        wlr-randr
        #wl-clipboard
        #wl-clipboard-x11
        #wl-clip-persist
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
        xorg.xkill
        xorg.xhost
        xclip
      appimage-run
      clipboard-jh
      google-drive-ocamlfuse
      gparted
      grc
      kdeconnect
      pavucontrol
      qbittorrent
      qdirstat
      rofi
      virt-manager
      zathura


    ### MISC PACKAGES
      discordchatexporter-cli
      speechd
  ];

  ######### (HM) ENVIRONMENT VARIABLES #########
  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.firefox-devedition}/bin/firefox";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_7}";
    EDITOR = "nvim";
    KHOJ_ADMIN_EMAIL = "firefliesandlightningbugs@gmail.com";
    KHOJ_ADMIN_PASSWORD = "NozndCZRacr7kpDx0UzWttZnXyJRL9qm";
    PAGER = "page";
    POSTGRES_USER = "postgres";
    POSTGRES_PASSWORD = "postgres";
    POSTGRES_HOST = "/run/postgresql/";
    MANPAGER = "nvim +Man!";
    NIXOS_OZONE_WL = "1";
    OBSIDIAN_REST_API_KEY = "3944368ac24bde98e46ee2d5b6425ce57d03399d799cdbc2453e10b8c407618a";
    OPENAI_API_BASE = "http://localhost:11434/v1/"; # https://localhost/v1/
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
    STEAM_DISABLE_BROWSER_SHUTDOWN_WORKAROUND=1;
    SUDOEDITOR = "vim";
    VISUAL = "vim";
  };

  ######### (HM) DOTFILES ########
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
      "mutt" = {
        source = ../../.config/mutt;
        recursive = true;
      };
      #"nvim" = {
      #  source = ./.config/nvim;
      #  recursive = true;
      #};
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
      "qutebrowser" = {
        source = ../../.config/qutebrowser;
        recursive = true;
      };
      "waybar" = {
        source = ../../.config/waybar;
        recursive = true;
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
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "zathura" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      };
    };
  };
}
