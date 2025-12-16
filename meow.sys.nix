{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  _g = import ./lib/globals.nix { inherit config; }; # My global variables
in
{
  imports = [
    ./cachix.nix

    ## CONTAINERS
    ./containers/gluetun.home.nix

    ## PROGRAMS
    ./programs/agl.sys.nix

    ## MODULES
    ./modules/gaming.nix
    ./modules/caddy-tailscale.sys.nix

    ## SECRETS
    inputs.sops-nix.nixosModules.sops

    ## SERVICES
    ./services/sunshine.sys.nix
    ./services/vaultwarden.sys.nix

    inputs.nixarr.nixosModules.default
    ./modules/nixarr.sys.nix

    ## WINDOW MANAGERS
    #./windowManagers/hyprland.sys.nix
  ];

  #-------- PACKAGES --------#
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      cudaSupport = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
      permittedInsecurePackages = [
        "aspnetcore-runtime-wrapped-6.0.36"
        "aspnetcore-runtime-6.0.36"
        "dotnet-runtime-7.0.20"
        "dotnet-core-combined"
        "dotnet-sdk-wrapped-6.0.428"
        "dotnet-sdk-6.0.428"
      ];
    };
    overlays = [ ];
  };

  environment.systemPackages = with pkgs; [
    btrfs-progs
    git
    home-manager
    ifuse
    libimobiledevice
    nixos-container
    nix-tree
    pinentry-curses
    polkit_gnome
    runc
    tailscale
    xsettingsd
    xorg.xrdb
  ];

  #------- MY MODULES -------#

  #--------- ENV ---------#
  environment.variables = {
    QT_QPA_PLATFORMTHEME = pkgs.lib.mkForce "qt6ct";
    QT_STYLE_PLUGIN = pkgs.lib.mkForce "qtstyleplugin-kvantum";
  };

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
  };

  #-------- PACKAGE MODULES --------#
  programs = {
    adb.enable = true;
    dconf = {
      enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    nbd.enable = false;
    nh = {
      enable = true;
      flake = "/home/neko/.nixcfg";
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
      ];
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
    docker.rootless = {
      enable = true;
    };
    docker = {
      enable = true;
    };
    podman = {
      enable = true;
      dockerCompat = false;
      dockerSocket.enable = false;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
    waydroid.enable = true;
  };

  #-------- GROUPS ---------#
  users.groups = {
    docker = { };
  };

  #-------- USERS --------#
  ##########################
  # Don't forget password! #
  ##########################
  users.users.neko = {
    isNormalUser = true;
    description = "neko";
    extraGroups = [
      "adbusers"
      "audio"
      "docker"
      "kvm"
      "input"
      "media"
      "networkmanager"
      "tss"
      "wheel"
    ];
    linger = true;
  };

  #-------- SECURITY --------#
  security = {
    pam.loginLimits = [
      #{
      #  domain = "@audio";
      #  item = "nice";
      #  type = "-";
      #  value = "-20";
      #}
      #{
      #  domain = "@audio";
      #  item = "rtprio";
      #  type = "-";
      #  value = "99";
      #}
    ];
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
    polkit.enable = true;
  };

  #-------- SERVICES --------#
  services = {
    avahi = {
      # CUPS (printing)
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    blueman.enable = true;
    gnome.sushi.enable = false;
    desktopManager = {
      gnome.enable = false;
      plasma6.enable = true;
    };
    displayManager = {
      defaultSession = "niri";
      sddm.enable = false;
      gdm.enable = true;
    };
    fail2ban.enable = true;
    flatpak.enable = true;
    guix.enable = false;
    llama-cpp = {
      enable = false;
      openFirewall = false;
      extraFlags = [ "" ];
    };
    lsfg-vk = {
      enable = true;
      ui.enable = true;
    };
    monado = {
      enable = false;
      defaultRuntime = false;
    };
    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
    ollama = {
      enable = false; # ## SEE PODMAN + HARBOR
      host = "0.0.0.0";
      openFirewall = false;
    };
    openssh.enable = true;
    printing.enable = true;
    resolved.enable = true;
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="*",GROUP="users", MODE="0660"
    '';
    xserver = {
      enable = true;
      windowManager = {
        bspwm.enable = false;
      };
      xkb.layout = "us";
      xkb.variant = "";
    };
  };

  #-------- SYSTEM --------#
  systemd = {
    user = {
      services = {
        polkit-kde-agent-1 = {
          description = "polkit kde interface";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };
    };
    settings.Manager = {
      DefaultTimeoutStopSec = "10s";
    };
    tmpfiles.rules = [
      "L+ /run/gdm/.config/monitors.xml - - - - ${builtins.readFile ./.config/monitors.xml}"
    ];
  };

  #-------- NETWORKING --------#
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller
  networking = {
    hostName = "meow";
    nameservers = [
      "100.100.100.100"
      "8.8.8.8"
      "1.1.1.1"
    ];
    search = [ "example.ts.net" ];
    firewall.checkReversePath = "loose";
    networkmanager.enable = true; # Enable Networking
    interfaces."enp6s0".wakeOnLan.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        2234 # Soulseek
        5173 # Grimoire
        # UxPlay
        7000
        7001
        7100
        8333 # SillyTavern
        25565 # MC SERVER
        25575 # MC RCON
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPorts = [
        2234 # Soulseek
        5173 # Grimoire
        # UxPlay
        6000
        6001
        7011
        5353 # AirPlay (iOS)
        8222 # Vault Warden
        8333 # SillyTavern
        25565 # MC SERVER
        25575 # MC RCON
        51820 # Wireguard port
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
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    extraConfig = {
      pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 128;
          "default.clock.min-quantum" = 128;
          "default.clock.max-quantum" = 256;
        };
      };
      pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "128/48000";
              pulse.default.req = "128/48000";
              pulse.max.req = "256/48000";
              pulse.min.quantum = "128/48000";
              pulse.max.quantum = "256/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "128/48000";
          resample.quality = 1;
        };
      };
    };
  };
  environment.etc = {
    "alsa/conf.d/60-a52-encoder.conf".source =
      pkgs.alsa-plugins + "/etc/alsa/conf.d/60-a52-encoder.conf";

    "alsa/conf.d/59.a52-lib.conf".text = ''
      pcm_type.a52 {
        lib "${pkgs.alsa-plugins}/lib/alsa-lib/libasound_module_pcm_a52.so"
      }
    '';
  };

  #-------- GPU --------#
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };
    nvidia = {
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = false;

      ### Experimental, and can cause sleep/suspend to fail.
    };
    nvidia-container-toolkit.enable = true;
    steam-hardware.enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    LIBVA_DRIVER_NAME = "nvidia";
  };
  environment.etc."X11/xorg.conf.d/10-nvidia-settings.conf".text = ''
    Section "Screen"
      Identifier "Screen0"
      Device "Device0"
      Monitor "Monitor0"
      DefaultDepth 24
      Option "Stereo" "0"
      Option "nvidiaXineramaInfoOrder" "DFP-7"
      Option "metamodes" "${_g.monitors.left.output}: nvidia-auto-select +${_g.monitors.left.pos.x}+${_g.monitors.left.pos.y} {rotation=right, ForceCompositionPipeline=On}, ${_g.monitors.center.output}: nvidia-auto-select +${_g.monitors.center.pos.x}+${_g.monitors.center.pos.y} {AllowGSYNCCompatible=On}, ${_g.monitors.right.output}: nvidia-auto-select +${_g.monitors.right.pos.x}+${_g.monitors.right.pos.y} {rotation=right, ForceCompositionPipeline=On}"
      Option "SLI" "Off"
      Option "MultiGPU" "Off"
      Option "BaseMosaic" "off"
      SubSection "Display"
        Depth 24
      EndSubSection
    EndSection
  '';
  # Setup displays
  services.xserver.displayManager.setupCommands = ''
    ${config.hardware.nvidia.package.settings}/bin/nvidia-settings --assign CurrentMetaMode=" \
    ${_g.monitors.left.output}: nvidia-auto-select +${_g.monitors.left.pos.x}+${_g.monitors.left.pos.y} {rotation=right, ForceCompositionPipeline=On}, \
    ${_g.monitors.center.output}: nvidia-auto-select +${_g.monitors.center.pos.x}+${_g.monitors.center.pos.y} {AllowGSYNCCompatible=On}, \
    ${_g.monitors.right.output}: nvidia-auto-select +${_g.monitors.right.pos.x}+${_g.monitors.right.pos.y} {rotation=right, ForceCompositionPipeline=On}"
  '';

  #-------- BOOTLOADER --------#
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModprobeConfig = ''
      options nvidia NVreg_EnableGpuFirmware=0
    '';
    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
      "nvidia.hdmi_deepcolor=1"
      "amd_pstate=active"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = {
      "vm.overcommit_memory" = 1;
      "vm.max_map_count" = lib.mkForce 16777216; # for S&BOX
    };
    supportedFilesystems = [ "ntfs" ];
  };

  #-------- POWER --------#
  powerManagement.enable = true;

  #-------- XDG PORTALS --------#
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
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
