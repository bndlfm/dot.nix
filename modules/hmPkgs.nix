{ pkgs,  ... }:{
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
    #upscayl
    yazi
    #ydotool
    zip
    zoxide
  ];
}
