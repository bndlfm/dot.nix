{ pkgs, ... }: {
  imports = [
    ../../programs/shell.home.nix
    ../../programs/neovim.home.nix
  ];

  home.stateVersion = "23.11";
  home.username = "server";
  home.homeDirectory = "/home/server";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        "nix-2.16.2"
      ];
    };
    overlays = [
    ];
  };

  home.packages = with pkgs; [

    #!!!! TEMP INSTALLS !!!!#
      distrobox
      ethtool
      zellij

    ### CLI
      age
      eza
      fd
      ffmpeg-full
      fzf
      gnugrep
      gopass
      jq
      libqalculate
      nix-index
      ripgrep
      silver-searcher
      trashy
      wireguard-tools
      zip
      zoxide

    ### TUI
      ### TOP-LIKES
        btop
        iotop
      ranger
      joshuto
        highlight
      page

    ### PROGRAMMING
      ### GIT
        git
        git-filter-repo
        git-lfs
        git-credential-gopass
      direnv
      dotnetCorePackages.sdk_8_0_2xx
      python3

    ### SYSTEM
      podman
      podman-compose
      winetricks
      wineWow64Packages.staging

    ### UTILITIES
      appimage-run
      clipboard-jh
      google-drive-ocamlfuse
      grc
      pkgs.kdePackages.kdeconnect-kde
      rofi
  ];

  ######### (HM) ENVIRONMENT VARIABLES #########
  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnetCorePackages.sdk_8_0_2xx}";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    OPENAI_API_BASE = "http://localhost:11434/v1/";
    VISUAL = "vim";
  };

  ######### (HM) DOTFILES ########
  xdg = {
    configFile = {
      "nvim" = {
        source = ../../.config/nvim;
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
      "yazi" = {
        source = ../../.config/yazi;
        recursive = true;
      };
    };
  };
}

