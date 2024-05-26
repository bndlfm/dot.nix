{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    #../../containers/pihole/pihole.nix
    #../../containers/retroarch-web.nix
    #../../containers/grimoire/grimoire.nix
    #../../containers/home-assistant.nix
    #../../containers/jellyfin.nix

    ../../services/tailscale.nix
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
    arion
    docker-client
    git
    home-manager
    jre
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
    networkd-dispatcher = {
      enable = true;
      rules = {
        "tailscale" = {
          script = ''
            #!${pkgs.runtimeShell}
            echo "Fixing UDP-GRO for Tailscale...."
            ethtool -K enp4s0 rx-udp-gro-forwarding on rx-gro-list off 
          '';
        };
      };
    };
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

  # Select internationalisation properties.
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
      #package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    nvidia-container-toolkit.enable = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  #services.xserver.videoDrivers = [ "nvidia" ];

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
  #  services.xserver.displayManager.setupCommands =
  #    let
  #      monitor-center = "DP-4";
  #      monitor-top = "HDMI-0";
  #      monitor-right = "DP-3";
  #    in
  #    ''
  #      ${config.hardware.nvidia.package.settings}/bin/nvidia-settings --assign CurrentMetaMode="${monitor-center}: nvidia-auto-select +0+1080 {AllowGSYNCCompatible=On}, ${monitor-top}: nvidia-auto-select +640+0 {ForceCompositionPipeline=On}, ${monitor-right}: nvidia-auto-select +2560+290 {rotation=right, ForceCompositionPipeline=On}"
  #    '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
