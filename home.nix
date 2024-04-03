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
    ];
  };

  home.packages = with pkgs; [
    ### CLI
    bat
    btop
    chafa
    eza
    fd
    ffmpeg-full
    file
    fzf
    git-lfs
    gnugrep
    libqalculate
    libnotify
    nix-index
    nvtopPackages.nvidia
    ollama
    pulsemixer
    ripgrep
    silver-searcher
    trashy
    xdragon

    ### EDITORS
    gimp

    ### GAMES
    crawlTiles
    protonup
    winetricks

    ### HYPRLAND
    hdrop
    hyprpaper
    hyprshot

    ### MEDIA
    mpd
    mpd-discord-rpc
    mpv
    ncmpcpp
    streamlink
    streamlink-twitch-gui-bin
    chatterino2
    yams
    yt-dlp
    zathura

    ### PASSWORDS
    git-credential-gopass
    gopass

    ### PROGRAMMING
    python3
    poetry
    meld
    nil
    codeium
    direnv

    ### SWAY TOOLS
    swaybg
    swayidle
    swaylock
    swaynotificationcenter

    ### TUI
    joshuto
    page
    ranger
    highlight

    ### THEMING
    base16-schemes
    font-awesome
    gyre-fonts
    nerdfonts
    ocs-url
    volantes-cursors

    ### Plasma5/QT5
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum

    ### SYSTEM
    google-drive-ocamlfuse
    qdirstat
    wineWow64Packages.staging

    ### WAYLAND SPECIFIC
    gammastep
    grimblast
    slurp
    nwg-look
      waybar
      waybar-mpris
      wttrbar
    #wl-clipboard
    #wl-clipboard-x11
    #wl-clip-persist
    wlr-randr

    ### XORG
    dunst
    eww
    jgmenu
    polybar
    nitrogen
    scrot
    tdrop
    xorg.xkill
    xorg.xhost
    xclip

    ### MISC PACKAGES
    appimage-run
    brave
    discordchatexporter-cli
    firefox-devedition
    grc
    gparted
    kdeconnect
    lxappearance
    pavucontrol
    docker-client
    podman
    podman-compose
    qbittorrent
    ripcord
    rofi
    speechd
    yazi
    #ydotool
    zip
    zoxide
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

