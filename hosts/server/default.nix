{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

  ### CONTAINERS
    ../../containers/pihole.sys.nix
    #../../containers/grimoire/grimoire.nix
    #../../containers/home-assistant.nix
    #../../containers/jellyfin.nix
    #../../containers/retroarch-web.nix

  ### MODULES
    ../../modules/caddy-tailscale.sys.nix
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cosmic.cachix.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
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

#------- SPECIALIZATION -------#
  ### SPECIALIZATION COMMETH
  specialisation = {
    PaperWM.configuration = {
      system.nixos.tags = [ "PaperWM" ];
      services = {
        xserver = {
          desktopManager = {
            gnome.enable = true;
          };
        };
      };
    };
    lxqt.configuration = {
      system.nixos.tags = [ "lxqt" ];
      services = {
        xserver = {
          desktopManager = {
            lxqt.enable = false;
          };
        };
      };
    };
  };

#------- PACKAGES -------#
  environment = {
    systemPackages = with pkgs; [
      ethtool
      git
    ];
    variables= {
      QT_QPA_PLATFORMTHEME = pkgs.lib.mkForce "qt6ct";
      QT_STYLE_PLUGIN = pkgs.lib.mkForce "qtstyleplugin-kvantum";
    };
    sessionVariables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_BIN_HOME = "$HOME/.local/bin";
      #XDG_RUNTIME_DIR = "/run/user/$(id -u)";
    };
  };

  #-------- PACKAGE MODULES --------#
  programs = {
    extra-container.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nbd.enable = false;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        cmake
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
    avahi = { # CUPS NETWORKING (PRINTING)
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    blueman.enable = true;
    desktopManager = {
      plasma6.enable = lib.mkIf (config.specialisation !={}) true;
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
    printing.enable = true; # CUPS (PRINTING)
    xserver = { # X11
      enable = true;
      displayManager.gdm.enable = true;
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
    vmVariant = {
      # used with nixos-rebuild build-vm
      virtualisation = {
        memorySize = "8192";
        cores = "2";
      };
    };
    vmVariantWithBootLoader = {
      # used with nixos-rebuild build-vm-bootloader
      virtualisation = {
        memorySize = "8192";
        cores = "2";
      };
    };
  };

  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
  '';



#------- NETWORKING -------#
  networking = {
    hostName = "nyaa";
    firewall = {
      enable = true;
      allowedTCPPorts = [
        53    #PIHOLE
        5173  #GRIMOIRE
        12525 #BITBURNER / NPM WATCH
        41641 #TAILSCALE
      ];
      allowedUDPPorts = [
        53    #PIHOLE
        5173  #GRIMOIRE
        12525 #BITBURNER / NPM WATCH
        41641 #TAILSCALE
      ];
    };
    networkmanager.enable = true;
  };


#------- SYSTEMD -------#
  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
    '';
  };


#------- USERS -------#
users = {
  users = {
    "neko" = {
      isNormalUser = true;
      description = "neko user";
      extraGroups = [ "audio" "podman" "networkmanager" "wheel" ];
      packages = with pkgs; [
        home-manager
      ];
    };
    "server" = {
      isNormalUser = true;
      description = "server";
      extraGroups = [ "audio" "podman" "networkmanager" "wheel" ];
      packages = with pkgs; [];
    };
    "nixosvmtest" = {
      isSystemUser = true;
      initialPassword = "test";
      group = "nixosvmtest";
    };
  };
  groups = {
    "nixosvmtest" = {};
  };
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
      option "TearFree" "1"
    '';
  };

  #------- SOUND -------#
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
