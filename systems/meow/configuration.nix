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
        "https://ai.cachix.org"
        "https://nix-gaming.cachix.org"
        #"https://chaotic-nyx.cachix.org"
        #"https://ezkea.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
      cudaSupport = true;
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
    git
    btrfs-progs
    home-manager
    (callPackage ../../theme/sddm-lain-wired.nix{}).sddm-lain-wired-theme
    quickemu
    runc
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
    dconf = {
      enable = true;
    };
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
      ];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

#-------- CONTAINERS / VM --------#
  virtualisation = {
    containers = {
      enable = true;
      storage.settings = {
        storage = {
          driver = "overlay";
          runroot = "/run/containers/storage";
          graphroot = "/var/lib/containers/storage";
          rootless_storage_path = "/tmp/containers-$USER";
          options.overlay.mountopt = "nodev,metacopy=on";
        };
      };
    };

    podman = {
      enable = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
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
  users.groups.distrobox = {};


  #-------- USERS --------#
  ##########################
  # Don't forget password! #
  ##########################
  users.users.neko = {
    isNormalUser = true;
    description = "neko";
    extraGroups = [ "networkmanager" "wheel" "input" "docker" "libvirtd" "tss" ];
    linger = true;
  };

  users.users.distrobox = {
    isSystemUser = true;
    description = "distrobox user";
    group = "distrobox";
  };

  #-------- SECURITY --------#
  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };

  #-------- SERVICES --------#
  services = {

    # keep enabled for CUPS (printing)
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    blueman.enable = true;

    displayManager =  {
      sddm = {
        enable = true;
      };
    };

    fail2ban = {
      enable = true;
    };

    flatpak.enable = true;

    ollama = {
      enable = false;
      acceleration = "cuda";
    };

    openssh.enable = true;

    postgresql = {
      enable = true;
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
      #displayManager = {
        #lightdm.enable = true;
      #};
      desktopManager = {
        plasma5.enable = true;
      };
      windowManager = {
        bspwm.enable = true;
      };
      xkb.layout = "us";
      xkb.variant = "";
    };
  };

  #-------- SYSTEM --------#
  systemd = {
    enableUnifiedCgroupHierarchy = false;
    user = {
      services = {
        polkit-kde-agent = {
          description = "polkit-kde-agent";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
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
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/8a82f24c-5b0d-4f5e-900d-a6e615f0dc77";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6BFC-BE4E";
      fsType = "vfat";
    };

    "/mnt/data" = {
      device = "/dev/disk/by-uuid/627b1de1-05e5-4596-8b3a-a009597f5ed6";
      fsType = "btrfs";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };

    "/media" = {
      device = "/dev/disk/by-uuid/fe4494de-0116-404f-9c8a-5011115eedbf";
      fsType = "btrfs";
      options = [
        "subvol=@media"
        "noatime"
        "nodiratime"
        "discard"
      ];
    };
  };


  #-------- NETWORKING --------#
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller
  networking = {
    hostName = "meow";
    networkmanager.enable = true; # Enable Networking
    nat = {
      enable = true;
      externalInterface = "enp6s0";
      internalInterfaces = [ "wg0" ];
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        5173 # Grimoire
        8000
        8096 # Jellyfin HTTP
        8920 # Jellyfin HTTPS
        11434 # Ollama
        5432 42110 # Khoj
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPorts = [
        1900 7359 # Jellyfin service autodiscovery
        5173 # Grimoire
        11434 # Ollama
        5432 42110 # Khoj
        51820 # Wireguard port
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
    #  wg0 = {
    #    ips = [ "192.168.1.1/24" ]; # "fc10:10:10::1/64"

    #    # NOTE: This allows the wireguard server to route your traffic to the internet and hence be like a VPN
    #    # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
    #    listenPort = 51820;

    #    # Path to the private key file.
    
    #    # NOTE: The private key can also be included inline via the privateKey option,
    #    # but this makes the private key world-readable; thus, using privateKeyFile is
    #    # recommended.
    #    privateKeyFile = "/etc/wireguard/privatekey/privatekey";

    #    #peers = [{
    #      # List of allowed peers.
    #      # Feel free to give a meaningful name
    #      # Public key of the peer (not a file path).
    #      # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.

    #      #publicKey = "Nl5DtuKE3HscxEuTTirditJ1pJAlmb9hjL7H/6JeFQ0="; # "fc10:10:10::2/128"
    #      #allowedIPs = [ "192.168.1.2/32" ];
    #      #endpoint = "192.168.1.25:51820";
    #      #persistentKeepalive = 25;
    #    }];
    #  };
    #};
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
  hardware = {
    nvidia = {
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
      package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
      #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #version = "545.29.06";
        #sha256_64bit = "sha256-grxVZ2rdQ0FsFG5wxiTI3GrxbMBMcjhoDFajDgBFsXs=";
        #sha256_aarch64 = "sha256-k7k22z5PYZdBVfuYXVcl9SFUMqZmK4qyxoRwlYyRdgU=";
        #openSha256 = "sha256-dktHCoESqoNfu5M73aY5MQGROlZawZwzBqs3RkOyfoQ=";
        #settingsSha256 = "sha256-YBaKpRQWSdXG8Usev8s3GYHCPqL8PpJeF6gpa2droWY=";
        #persistencedSha256 = "sha256-ci86XGlno6DbHw6rkVSzBpopaapfJvk0+lHcR4LDq50=";

        #ibtSupport = true;
      #};
    };

    nvidia-container-toolkit.enable = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
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
      Option "metamodes" "HDMI-0: nvidia-auto-select +322+0, DP-4: nvidia-auto-select +0+1080, DP-3: nvidia-auto-select +2560+290, DP-0: off"
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
      monitor-right = "DP-3";
    in
    ''
      ${config.hardware.nvidia.package.settings}/bin/nvidia-settings --assign CurrentMetaMode="${monitor-center}: nvidia-auto-select +0+1080 {AllowGSYNCCompatible=On}, ${monitor-top}: nvidia-auto-select +640+0 {ForceCompositionPipeline=On}, ${monitor-right}: nvidia-auto-select +2560+290 {rotation=right, ForceCompositionPipeline=On}"
    '';


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
    supportedFilesystems = [ "ntfs" ];
  };


  #-------- POWER --------#
  powerManagement.enable = false;


  #-------- XDG PORTALS --------#
  xdg = {
    portal = {
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
    mime = {
      defaultApplications = {
        "application/pdf" = [ "zathura" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
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
