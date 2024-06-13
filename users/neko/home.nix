{ pkgs, lib, ... }:
let
  homeDir = "/home/neko";
in {
  home.stateVersion = "23.11";
  home.username = "neko";
  home.homeDirectory = "/home/neko";

  imports = [
    ### PROGRAMS
      ../../programs/hm/firefox.nix
      ../../programs/hm/fish.nix
      ../../programs/hm/gnome-shell.nix
      ../../programs/hm/kitty.nix
      ../../programs/hm/ncmpcpp.nix
      ../../programs/hm/neovim.nix
      ../../programs/hm/yazi.nix

      ../../programs/hm/misc_programs.nix

    ### SERVICES
      ../../services/hm/espanso.nix
      ../../services/hm/flatpak.nix

      ../../services/hm/misc_services.nix

    ### MODULES
      ../../modules/hm/windowManagers.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz")
          { inherit pkgs; };
        fish = pkgs.fish.overrideAttrs (oldAttrs: {
          propagatedBuildInputs = oldAttrs.buildInputs ++ [ pkgs.python3 pkgs.python3Packages.openai ]; # FOR fish_ai.fish
        });
      };
      permittedInsecurePackages = [];
    };
    overlays = [
      (import ../../overlays/overlays.nix)
    ];
  };

  home.packages = with pkgs; [
    #!!!! TEMP INSTALLS !!!!#
      distrobox
      godot_4
      godot_4-export-templates
      (pkgs.callPackage ../../packages/warp-term.nix {})

    ### AI
      upscayl

    ### BROWSER
      firefox-devedition
      qutebrowser

    ### CLI
      age
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
      (prismlauncher.override{withWaylandGLFW=true;})
      glfw-wayland-minecraft

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
        git-credential-manager
        git-credential-gopass
      codeium
      direnv
      dotnet-sdk_7
      meld

    ### SOCIAL
      chatterino2
      discord
      ripcord

    ### SYSTEM
      ### Plasma5-6/QT5-6
        qt6Packages.qt6ct
        qt6Packages.qtstyleplugin-kvantum
        ksshaskpass
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
        wofi
        wttrbar
        wlr-randr
        wl-clipboard
        wl-clipboard-x11
        wl-clip-persist
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
        #xclip
      appimage-run
      clipboard-jh
      google-drive-ocamlfuse
      gparted
      grc
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
    EDITOR  = "nvim";
    _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd";
    KHOJ_ADMIN_EMAIL = "firefliesandlightningbugs@gmail.com";
    KHOJ_ADMIN_PASSWORD = "NozndCZRacr7kpDx0UzWttZnXyJRL9qm";
    PAGER = "nvim +Man!";
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
    #mime.enable = true;
    #mimeApps = {
    #  enable = true;
    #  defaultApplications = {
    #    "application/pdf" = [ "zathura" ];
    #    "text/html" = [ "firefox.desktop" ];
    #    "x-scheme-handler/http" = [ "firefox.desktop" ];
    #    "x-scheme-handler/https" = [ "firefox.desktop" ];
    #    "x-scheme-handler/about" = [ "firefox.desktop" ];
    #    "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    #  };
    #};
  };
}

