{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    #../../containers/pihole/pihole.nix
    #../../containers/retroarch-web.nix
    #../../containers/grimoire/grimoire.nix
    #../../containers/home-assistant.nix
    #../../containers/jellyfin.nix

    #../../services/tailscale.nix
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cosmic.cachix.org/"
        "https://ai.cachix.org"
        "https://nix-gaming.cachix.org"
        #"https://chaotic-nyx.cachix.org"
        #"https://ezkea.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        #"nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        #"chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        #"ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      qt5 = {
        enable = true;
        platformTheme  = "qt5ct";
          style = {
            package = pkgs.utterly-nord-plasma;
            name = "Utterly Nord Plasma";
          };
        };
      qt6 = {
        enable = true;
        platformTheme  = "qt6ct";
          style = {
            package = pkgs.utterly-nord-plasma;
            name = "Utterly Nord Plasma";
          };
        };
      };
    overlays = [
      #(import ../../overlays/overlays.nix)
    ];
  };

  environment.systemPackages = with pkgs; [
    arion
    docker-client
    ethtool
    git
    home-manager
  ];

  environment.variables= {
    QT_QPA_PLATFORMTHEME = pkgs.lib.mkForce "qt6ct";
    QT_STYLE_PLUGIN = pkgs.lib.mkForce "qtstyleplugin-kvantum";
  };

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    #XDG_RUNTIME_DIR = "/run/user/$(id -u)";
  };

  #-------- PACKAGE MODULES --------#
  programs = {
    extra-container.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    nbd.enable = false;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        cmake
        jre
      ];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

#------- SERVICES -------#
  services = {
    avahi = { # CUPS (printing)
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    blueman.enable = true;
    displayManager =  {
      #sddm.enable = false; # NOTE: See Specialisations
    };
    desktopManager = {
      #plasma6.enable = false; # NOTE: See Specialisations
    };
    fail2ban.enable = true;
    flatpak.enable = true;
    ollama = {
      enable = false;
      acceleration = "cuda";
    };
    openssh.enable = true;
    postgresql = {
      enable = false;
      ensureDatabases = [ "khoj" ];
      enableTCPIP = false;
      extraPlugins = ps: with pkgs; [
        postgresqlPackages.pgvector
      ];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database DBuser auth-method
        local all      all    trust
      '';
    };

    ## Enable CUPS to print documents.
    printing.enable = true;

    ## X11
    xserver = {
      enable = true;
      desktopManager = {
      };
      windowManager = {
        bspwm.enable = true;
      };
      xkb.layout = "us";
      xkb.variant = "";
    };
  };

#-------- CONTAINERS / VM --------#
  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dnsname_enabled = true;
    };
  };

  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
  '';

#------- SPECIALIZATION -------#
  specialisation = {
    lxqt.configuration = {
      system.nixos.tags = [ "lxqt" ];
      services = {
        displayManager.sddm.enable = true;
        xserver.desktopManager.lxqt.enable = true;
      };
    };
    kde.configuration = {
      system.nixos.tags = [ "kde" ];
      services = {
        displayManager.sddm.enable = true;
        desktopManager.plasma6.enable = true;
      };
    };
    cosmic.configuration = {
      system.nixos.tags = [ "cosmic" ];
      services = {
        displayManager.cosmic-greeter.enable = true;
        desktopManager.cosmic.enable = true;
      };
    };
  };

#------- NETWORKING -------#
  networking = {
    hostName = "nyaa";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        53    #PIHOLE
        5173  #GRIMOIRE
        41641 #TAILSCALE
      ];
      allowedUDPPorts = [
        53    #PIHOLE
        5173  #GRIMOIRE
        41641 #TAILSCALE
      ];
    };
    networkmanager.enable = true;
  };

#------- USERS -------#
  users.users."server" = {
    isNormalUser = true;
    description = "server";
    extraGroups = [ "podman" "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  users.users."neko" = {
    isNormalUser = true;
    description = "neko user";
    extraGroups = [ "podman" "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

#------- STORAGE / DRIVES -------#
  fileSystems."/media" = {
    device = "/dev/disk/by-uuid/fe4494de-0116-404f-9c8a-5011115eedbf";
    fsType = "btrfs";
    options = [ "subvol=@media" "noatime" "compress=zstd:3" ];
  };

#------- BOOTLOADER -------#
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [];
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };

#------- i18n / internationalization -------#
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  #-------- GPU --------#
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
      ];
    };
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  services.xserver = {
    videoDrivers = [ "intel" ];
    deviceSection = ''
      option "DRI" "2"
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
