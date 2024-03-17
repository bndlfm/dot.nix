# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [
  ];

  #-------- PACKAGES --------#
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        #"https://ai.cachix.org"
        "https://nix-gaming.cachix.org"
        #"https://chaotic-nyx.cachix.org"
        #"https://ezkea.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        #"ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
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
      cudaSupport = true;
    };
    overlays = [
      (import ./overlays/overlays.nix)
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    btrfs-progs
    docker
    home-manager
    hyprland
    hyprland-protocols
    neovim-unwrapped
    runc
    sops
  ];

  #-------- PACKAGE MODULES --------#
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        cmake
      ];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports firewall for Source Dedicated Server
    };
  };

  #-------- CONTAINERS / VM --------#
  virtualisation = {
    containers.enable = true;
    containers.storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        rootless_storage_path = "/tmp/containers-$USER";
        options.overlay.mountopt = "nodev,metacopy=on";
      };
      #cdi.dynamic.nvidia.enable = true;
    };
    podman = {
      enable = true;
      enableNvidia = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd.enable = true;
    oci-containers = {
      backend = "podman";
      containers."jellyfin" = {
        image = "docker.io/jellyfin/jellyfin:latest";
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        autoStart = true;
        ports = [
          "8096:8096"
          "8920:8920"
          "1900:1900"
          "7359:7359"
        ];
        environment = {
          NVIDIA_VISIBLE_DEVICES = "all";
          NVIDIA_DRIVER_CAPABILITIES = "all";
          JELLYFIN_PublishedServerUrl = "192.168.1.5";
        };
        volumes = [
          "/media/.cache:/cache"
          "/media/.jellyfin:/config"
          "/media:/media"
        ];
      };
    };
  };

  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
      fi
  '';



  #-------- GROUPS ---------#
  users.groups.distrobox = { };
  users.groups.steamhead = { };


  #-------- USERS --------#
  ##########################
  # Don't forget password! #
  ##########################
  users.users.neko = {
    isNormalUser = true;
    description = "neko";
    extraGroups = [ "networkmanager" "wheel" "input" "docker" "libvirtd" ];
    linger = true;
  };

  users.users.distrobox = {
    isSystemUser = true;
    description = "distrobox user";
    group = "distrobox";
  };

  #-------- SERVICES --------#
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    ## Enable Flatpak
    flatpak.enable = true;

    ## Enable the OpenSSH daemon.
    openssh.enable = true;

    ## Enable CUPS to print documents.
    printing.enable = true;

    ## X11
    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      windowManager.bspwm.enable = true;
      xkb.layout = "us";
      xkb.variant = "";
    };
  };
  users.users.neko.packages = with pkgs; [
    sxhkd
  ];

  #-------- SYSTEM --------#
  systemd = {
    enableUnifiedCgroupHierarchy = false;
    user = {
      services = {
        polkit-gnome-authentication-agent-1 = {
          description = "polkit-gnome-authentication-agent-1";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
        ytoold.enable = true;
      };
    };
    extraConfig = ''
      DefaultTimeoutStopSec = 10s
    '';
  };

  #-------- FILESYSTEM --------#
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/627b1de1-05e5-4596-8b3a-a009597f5ed6";
    fsType = "btrfs";
    options = [
      "noatime"
      "nodiratime"
      "discard"
    ];
  };
  fileSystems."/media" = {
    device = "/dev/disk/by-uuid/fe4494de-0116-404f-9c8a-5011115eedbf";
    fsType = "btrfs";
    options = [
      "subvol=@media"
      "noatime"
      "nodiratime"
      "discard"
    ];
  };


  #-------- NETWORKING --------#
  networking = {
    hostName = "meow";
    networkmanager.enable = true; # Enable Networking
    firewall = {
      enable = true;
      allowedTCPPorts = [
        8000
        8096 # Jellyfin HTTP
        8920 # Jellyfin HTTPS
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPorts = [
        1900 # Jellyfin service autodiscovery
        7359 # Also Jellyfin service autodiscovery
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };


  #-------- AUDIO --------#
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    ## use the example session manager (no others are packaged yet so this is
    ## enabled by default, no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  #-------- GPU --------#
  hardware.nvidia = {
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.etc."X11/xorg.conf.d/10-nvidia-settings.conf".text = /* sh */ ''
    Section "Screen"
      Identifier "Screen0"
      Device "Device0"
      Monitor "Monitor0"
      DefaultDepth 24
      Option "Stereo" "0"
      Option "nvidiaXineramaInfoOrder" "DFP-7" 
      Option "metamodes" "HDMI-0: nvidia-auto-select +322+0, DP-4: nvidia-auto-select +0+1080, DP-0: off"
      Option "SLI" "Off"
      Option "MultiGPU" "Off"
      Option "BaseMosaic" "off"
      SubSection "Display"
        Depth 24
      EndSubSection
    EndSection
  '';

  # Setup displays
  services.xserver.displayManager.setupCommands =
    let
      monitor-center = "DP-4";
      monitor-top = "HDMI-0";
    in
    ''
      ${config.hardware.nvidia.package.settings}/bin/nvidia-settings --assign CurrentMetaMode="DP-4: nvidia-auto-select +0+1080, HDMI-0: nvidia-auto-select +322+0, DP-0: off"
    '';
  # old:
  #${pkgs.xorg.xrandr}/bin/xrandr --output ${monitor-center} --primary --mode 2560x1440 --pos 0x1080 --rate 144.00 --rotate normal --output ${monitor-top} --mode 1920x1080 --rate 60.00 --pos 322x0

  #-------- BOOTLOADER --------#
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModprobeConfig = '''';
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "nvidia.modesetting=1" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = { "vm.overcommit_memory" = 1; };
  };

  #-------- POWER --------#
  powerManagement.enable = false;

  #-------- XDG PORTALS --------#
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [
          "kde"
          "gtk"
        ];
      };
      kde = {
        default = [
          "kde"
          "gtk"
        ];
      };
      gnome = {
        default = [
          "gtk"
          "kde"
        ];
      };
      hyprland = {
        default = [
          "hyprland"
          "kde"
        ];
      };
    };
  };


  #-------- TZ/i18n --------#
  # Set your time zone.
  time.timeZone = "America/Chicago";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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




  ##############################################################################
  ## This value determines the NixOS release from which the default           ##
  ## settings for stateful data, like file locations and database versions    ##
  ## on your system were taken. It‘s perfectly fine and recommended to leave  ##
  ## this value at the release version of the first install of this system.   ##
  ## Before changing this value read the documentation for this option        ##
  ## (e.g. man configuration.nix or on https://nixos.org/nixos/options.html). ##
  ##############################################################################
  system.stateVersion = "23.11"; # Did you read the comment?

}
