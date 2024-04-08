{ pkgs, ... }:{

  imports = [
    #./modules/hmFlatpak.nix
    ./modules/hmServices.nix

    ./modules/hmPrograms.nix
    ./modules/fish.nix
    ./modules/kitty.nix
    ./modules/ncmpcpp.nix
    ./modules/neovim.nix
    ./modules/yazi.nix

    ./modules/windowManagers.nix
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
      ];
    };
    overlays = [
      (import ./overlays/overlays.nix)
    ];
  };

  home.packages = with pkgs; [
    ### CLI
    bat
    chafa
    eza
    fd
    ffmpeg-full
    file
    fzf
    git-lfs
    gnugrep
    libnotify
    libqalculate
    nix-index
    ollama
    pulsemixer
    ripgrep
    silver-searcher
    trashy
    xdragon
    yt-dlp
    zip
    zoxide

    ### TUI
    highlight
    joshuto
    page
    ranger

        ### TOP-LIKES
        btop
        iotop
        nvtopPackages.nvidia

    ### EDITORS
    gimp

    ### GAMES
    crawlTiles

    ### MEDIA
    mpd
    mpd-discord-rpc
    mpv
    ncmpcpp
    streamlink
    streamlink-twitch-gui-bin
    zathura

    ### PASSWORDS
    git-credential-gopass
    gopass

    ### PROGRAMMING
    codeium
    direnv
    dotnet-sdk_7
    meld
    #nil
    python3
    poetry

    ### SOCIAL
    chatterino2
    ripcord

    ### SYSTEM
    podman
    podman-compose
    protonup
    winetricks
    wineWow64Packages.staging

        ### Plasma5-6/QT5-6
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qt5ct
        qt6Packages.qt6ct
        qt6Packages.qtstyleplugin-kvantum

    ### THEMING
    base16-schemes
    font-awesome
    gyre-fonts
    nerdfonts
    ocs-url
    volantes-cursors

    ### UTILITIES
    appimage-run
    google-drive-ocamlfuse
    gparted
    grc
    kdeconnect
    pavucontrol
    qbittorrent
    qdirstat
    quicksynergy
    rofi
    synergy

        ### WAYLAND SPECIFIC
        gammastep
        grimblast
        slurp
        nwg-look
        waybar
        waybar-mpris
        wttrbar
        wlr-randr
        #wl-clipboard
        #wl-clipboard-x11
        #wl-clip-persist

            ### SWAY TOOLS
            swaybg
            swayidle
            swaylock
            swaynotificationcenter

            ### HYPRLAND
            hdrop
            hyprpaper
            hyprshot

        ### XORG TOOLS
        dunst
        eww
        jgmenu
        polybar
        nitrogen
        scrot
        sxhkd
        tdrop
        xorg.xkill
        xorg.xhost
        xclip


    ### MISC PACKAGES
    brave
    discordchatexporter-cli
    firefox-devedition
    speechd
  ];

  ######### (HM) ENVIRONMENT VARIABLES #########
  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_7}";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    NIXOS_OZONE_WL = "1";
    OBSIDIAN_REST_API_KEY = "3944368ac24bde98e46ee2d5b6425ce57d03399d799cdbc2453e10b8c407618a";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
    STEAM_DISABLE_BROWSER_SHUTDOWN_WORKAROUND=1;
    SUDOEDITOR = "vim";
    VISUAL = "vim";
  };

  ######### (HM) DOTFILES ########
  xdg.configFile = {
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
    "sxhkd" = {
      source = ./.config/sxhkd;
      recursive = true;
    };
    "tridactyl" = {
      source = ./.config/tridactyl;
      recursive = true;
    };
    "qutebrowser" = {
      source = ./.config/qutebrowser;
      recursive = true;
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
}

