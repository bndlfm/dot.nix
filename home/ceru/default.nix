{ pkgs, ... }:
{
  imports = [
    ## PROGS BRAH
    ../../programs/shell/default.nix
    ../../programs/neovim.home.nix

    ## CONTAINERS
    ../../containers/homeassistant.home.nix
  ];

  home.stateVersion = "23.11";
  home.username = "ceru";
  home.homeDirectory = "/home/ceru";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
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

    ### OPENCLAW
    _openclaw
    _bird
    _blogwatcher
    _camsnap
    _clawdhub
    _gifgrep
    _gogcli
    _goplaces
    _mcporter
    _nano-pdf
    _songsee
    _summarize
    _sag

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
    };
  };
}
