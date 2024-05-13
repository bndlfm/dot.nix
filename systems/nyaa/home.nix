{ pkgs, ... }: {
  imports = [
    ../../programs/fish.nix
    ../../programs/neovim.nix
    ../../programs/yazi.nix
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
      zellij

    ### CLI
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

    ### THEMING
      ### FONTS
        rictydiminished-with-firacode
        font-awesome
        gyre-fonts
        nerdfonts
        noto-fonts-emoji-blob-bin
      base16-schemes

    ### UTILITIES
      appimage-run
      clipboard-jh
      google-drive-ocamlfuse
      grc
      kdeconnect
      rofi

    ### MISC PACKAGES
      discordchatexporter-cli
      speechd
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
      #"nvim" = {
      #  source = ./.config/nvim;
      #  recursive = true;
      #};
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

