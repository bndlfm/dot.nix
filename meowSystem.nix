{
  config,
  pkgs,
  ...
}:
let
  monitors = {
    left = {
      output = "HDMI-A-1";
      pos = {
        x = "0";
        y = "0";
      };
      resolution = {
        width = 1920;
        height = 1200;
      };
      rate = 60;
    };

    center = {
      output = "DP-1";
      pos = {
        x = "1200";
        y = "0";
      };
      resolution = {
        width = 2560;
        height = 1440;
      };
      rate = 144;
    };

    right = {
      output = "HDMI-A-3";
      pos = {
        x = "3760";
        y = "0";
      };
      resolution = {
        width = 1920;
        height = 1200;
      };
      rate = 60;
    };
  };
in
{
  imports = [
    ./cachix.nix

    ### PROGRAMS
      ./programs/steam.sys.nix
    ### CONTAINERS

    ### MODULES
      ./modules/tailscale.sys.nix
    ### SERVICES
      ./services/sunshine.sys.nix
  ];

  #-------- PACKAGES --------#
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      trusted-substituters = [ ];
      trusted-public-keys = [ ];
      };
    };

  nixpkgs = {
    config = {
      allowUnfree = true;
      cudaSupport = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz")
          { inherit pkgs; };
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
    git
    btrfs-progs
    home-manager
    pinentry-curses
    polkit_gnome
    runc
    tailscale
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
  };

  #-------- PACKAGE MODULES --------#
  programs = {
    darling.enable = false;
    dconf = {
      enable = true;
      };
    gamescope = {
      enable = true;
      capSysNice = true;
      };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
      };
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
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
      package = pkgs.docker_27;
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
    docker = {};
  };


  #-------- USERS --------#
  ##########################
  # Don't forget password! #
  ##########################
    users.users.neko = {
      isNormalUser = true;
      description = "neko";
      extraGroups = [ "networkmanager" "wheel" "input" "docker" "media" "libvirtd" "tss" ];
      linger = true;
      };


  #-------- SECURITY --------#
  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
      };
      polkit.enable = true;
    };


  #-------- SERVICES --------#
  services = {
    avahi = { # CUPS (printing)
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      };
    blueman.enable = true;
    desktopManager = {
      plasma6.enable = false;
      };
    displayManager =  {
      sddm.enable = false;
      };
    fail2ban.enable = false;
    flatpak.enable = true;
    guix.enable = false;
    llama-cpp = {
      enable = false;
      openFirewall = false;
      extraFlags = [ "" ];
      };
    monado = {
      enable = true;
      defaultRuntime = true;
      };
    ollama = {
      enable = false; ### SEE PODMAN + HARBOR
      acceleration = "cuda";
      host = "0.0.0.0";
      openFirewall = false;
      };
    openssh.enable = true;
    printing.enable = true;
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="*",GROUP="users", MODE="0660"
      '';
    vaultwarden = {
      enable = true;
      backupDir = "/mnt/data/.vaultwarden";
    };
    xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
        lightdm.enable = false;
        };
      desktopManager = {
        gnome.enable = true;
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
    user = {
      services = {
        monado.environment = {
          STEAMVR_LH_ENABLE = "1";
          XRT_COMPOSITOR_COMPUTE = "1";
        };
        polkit-gnome-authentication-agent-1 = {
          description = "polkit gnome interface";
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
      };
    };
    extraConfig = ''
      DefaultTimeoutStopSec = 10s
    '';
    tmpfiles.rules = [
      "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
        <monitors version="2">
          <configuration>
            <layoutmode>logical</layoutmode>
            <logicalmonitor>
              <x>322</x>
              <y>0</y>
              <scale>1</scale>
              <monitor>
                <monitorspec>
                  <connector>HDMI-1</connector>
                  <vendor>DEL</vendor>
                  <product>DELL U2417H</product>
                  <serial>XVNNT79EDJGL</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>0</x>
              <y>1080</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-3</connector>
                  <vendor>AUS</vendor>
                  <product>ASUS VG32V</product>
                  <serial>0x0000ce0e</serial>
                </monitorspec>
                <mode>
                  <width>2560</width>
                  <height>1440</height>
                  <rate>143.972</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <disabled>
              <monitorspec>
                <connector>DP-1</connector>
                <vendor>NVD</vendor>
                <product>0x0000</product>
                <serial>0x00000000</serial>
              </monitorspec>
            </disabled>
          </configuration>
          <configuration>
            <layoutmode>physical</layoutmode>
            <logicalmonitor>
              <x>3760</x>
              <y>0</y>
              <scale>1</scale>
              <transform>
                <rotation>right</rotation>
                <flipped>no</flipped>
              </transform>
              <monitor>
                <monitorspec>
                  <connector>DP-3</connector>
                  <vendor>DEL</vendor>
                  <product>DELL U2412M</product>
                  <serial>YMYH14740GTS</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1200</height>
                  <rate>59.950</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>1200</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-1</connector>
                  <vendor>AUS</vendor>
                  <product>ASUS VG32V</product>
                  <serial>0x0000ce0e</serial>
                </monitorspec>
                <mode>
                  <width>2560</width>
                  <height>1440</height>
                  <rate>143.972</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1</scale>
              <transform>
                <rotation>right</rotation>
                <flipped>no</flipped>
              </transform>
              <monitor>
                <monitorspec>
                  <connector>DP-2</connector>
                  <vendor>DEL</vendor>
                  <product>DELL U2412M</product>
                  <serial>YMYH142S5K9S</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1200</height>
                  <rate>59.950</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
          <configuration>
            <layoutmode>physical</layoutmode>
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-1</connector>
                  <vendor>AUS</vendor>
                  <product>ASUS VG32V</product>
                  <serial>0x0000ce0e</serial>
                </monitorspec>
                <mode>
                  <width>2560</width>
                  <height>1440</height>
                  <rate>143.972</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>2560</x>
              <y>0</y>
              <scale>1</scale>
              <transform>
                <rotation>right</rotation>
                <flipped>no</flipped>
              </transform>
              <monitor>
                <monitorspec>
                  <connector>DP-2</connector>
                  <vendor>SAM</vendor>
                  <product>SMS22A200/460</product>
                  <serial>HCLC907701</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
          <configuration>
            <layoutmode>logical</layoutmode>
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1</scale>
              <transform>
                <rotation>right</rotation>
                <flipped>no</flipped>
              </transform>
              <monitor>
                <monitorspec>
                  <connector>HDMI-1</connector>
                  <vendor>DEL</vendor>
                  <product>DELL U2417H</product>
                  <serial>XVNNT79EDJGL</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>1080</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-1</connector>
                  <vendor>AUS</vendor>
                  <product>ASUS VG32V</product>
                  <serial>0x0000ce0e</serial>
                </monitorspec>
                <mode>
                  <width>2560</width>
                  <height>1440</height>
                  <rate>143.972</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>4720</x>
              <y>0</y>
              <scale>1</scale>
              <monitor>
                <monitorspec>
                  <connector>None-1</connector>
                  <vendor>unknown</vendor>
                  <product>unknown</product>
                  <serial>unknown</serial>
                </monitorspec>
                <mode>
                  <width>1024</width>
                  <height>768</height>
                  <rate>59.999</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>3640</x>
              <y>0</y>
              <scale>1</scale>
              <transform>
                <rotation>right</rotation>
                <flipped>no</flipped>
              </transform>
              <monitor>
                <monitorspec>
                  <connector>DP-2</connector>
                  <vendor>SAM</vendor>
                  <product>SMS22A200/460</product>
                  <serial>HCLC907701</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
          <configuration>
            <layoutmode>physical</layoutmode>
            <logicalmonitor>
              <x>322</x>
              <y>0</y>
              <scale>1</scale>
              <monitor>
                <monitorspec>
                  <connector>HDMI-1</connector>
                  <vendor>DEL</vendor>
                  <product>DELL U2417H</product>
                  <serial>XVNNT79EDJGL</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>0</x>
              <y>1080</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-3</connector>
                  <vendor>AUS</vendor>
                  <product>ASUS VG32V</product>
                  <serial>0x0000ce0e</serial>
                </monitorspec>
                <mode>
                  <width>2560</width>
                  <height>1440</height>
                  <rate>143.972</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <disabled>
              <monitorspec>
                <connector>DP-1</connector>
                <vendor>NVD</vendor>
                <product>0x0000</product>
                <serial>0x00000000</serial>
              </monitorspec>
            </disabled>
          </configuration>
          <configuration>
            <layoutmode>physical</layoutmode>
            <logicalmonitor>
              <x>0</x>
              <y>147</y>
              <scale>1</scale>
              <transform>
                <rotation>right</rotation>
                <flipped>no</flipped>
              </transform>
              <monitor>
                <monitorspec>
                  <connector>HDMI-1</connector>
                  <vendor>DEL</vendor>
                  <product>DELL U2417H</product>
                  <serial>XVNNT79EDJGL</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>3640</x>
              <y>238</y>
              <scale>1</scale>
              <transform>
                <rotation>right</rotation>
                <flipped>no</flipped>
              </transform>
              <monitor>
                <monitorspec>
                  <connector>DP-2</connector>
                  <vendor>SAM</vendor>
                  <product>SMS22A200/460</product>
                  <serial>HCLC907701</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>1080</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-1</connector>
                  <vendor>AUS</vendor>
                  <product>ASUS VG32V</product>
                  <serial>0x0000ce0e</serial>
                </monitorspec>
                <mode>
                  <width>2560</width>
                  <height>1440</height>
                  <rate>143.972</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
          <configuration>
            <layoutmode>physical</layoutmode>
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1</scale>
              <transform>
                <rotation>right</rotation>
                <flipped>no</flipped>
              </transform>
              <monitor>
                <monitorspec>
                  <connector>HDMI-1</connector>
                  <vendor>DEL</vendor>
                  <product>DELL U2417H</product>
                  <serial>XVNNT79EDJGL</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>1080</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-1</connector>
                  <vendor>AUS</vendor>
                  <product>ASUS VG32V</product>
                  <serial>0x0000ce0e</serial>
                </monitorspec>
                <mode>
                  <width>2560</width>
                  <height>1440</height>
                  <rate>143.972</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>4720</x>
              <y>0</y>
              <scale>1</scale>
              <monitor>
                <monitorspec>
                  <connector>None-1</connector>
                  <vendor>unknown</vendor>
                  <product>unknown</product>
                  <serial>unknown</serial>
                </monitorspec>
                <mode>
                  <width>1024</width>
                  <height>768</height>
                  <rate>59.999</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>3640</x>
              <y>0</y>
              <scale>1</scale>
              <transform>
                <rotation>right</rotation>
                <flipped>no</flipped>
              </transform>
              <monitor>
                <monitorspec>
                  <connector>DP-2</connector>
                  <vendor>SAM</vendor>
                  <product>SMS22A200/460</product>
                  <serial>HCLC907701</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
          <configuration>
            <layoutmode>logical</layoutmode>
            <logicalmonitor>
              <x>0</x>
              <y>147</y>
              <scale>1</scale>
              <transform>
                <rotation>right</rotation>
                <flipped>no</flipped>
              </transform>
              <monitor>
                <monitorspec>
                  <connector>HDMI-1</connector>
                  <vendor>DEL</vendor>
                  <product>DELL U2417H</product>
                  <serial>XVNNT79EDJGL</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>3640</x>
              <y>238</y>
              <scale>1</scale>
              <transform>
                <rotation>right</rotation>
                <flipped>no</flipped>
              </transform>
              <monitor>
                <monitorspec>
                  <connector>DP-2</connector>
                  <vendor>SAM</vendor>
                  <product>SMS22A200/460</product>
                  <serial>HCLC907701</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>1080</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-1</connector>
                  <vendor>AUS</vendor>
                  <product>ASUS VG32V</product>
                  <serial>0x0000ce0e</serial>
                </monitorspec>
                <mode>
                  <width>2560</width>
                  <height>1440</height>
                  <rate>143.972</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
        </monitors>
      ''}"
    ];
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
      device = "/dev/disk/by-uuid/ad281e3a-7c33-48e2-be75-2b6433acee04";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "defaults"
        ];
      };

    "/data" = {
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
    nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
    search = [ "example.ts.net" ];
    firewall.checkReversePath = "loose";
    networkmanager.enable = true; # Enable Networking
    interfaces."enp6s0".wakeOnLan.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        5173 # Grimoire
        8333 # SillyTavern
        8096 # Jellyfin HTTP
        8920 # Jellyfin HTTPS
        #25565 # MC SERVER
        #25575 # MC RCON
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
        5353 # AirPlay (iOS)
        8333 # SillyTavern
        #25565 # MC SERVER
        #25575 # MC RCON
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
  };

  #-------- GPU --------#
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;

      ### Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;

      ### Fine-grained power management. Turns off GPU when not in use.
      ### Experimental Turing+
      ### Use the NVidia open source dkms kernel module
      ### https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      open = false;
      nvidiaSettings = true;
    };
    nvidia-container-toolkit.enable = true;
    steam-hardware.enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.etc."X11/xorg.conf.d/10-nvidia-settings.conf".text = ''
    Section "Screen"
      Identifier "Screen0"
      Device "Device0"
      Monitor "Monitor0"
      DefaultDepth 24
      Option "Stereo" "0"
      Option "nvidiaXineramaInfoOrder" "DFP-7"
      Option "metamodes" "${monitors.left.output}: nvidia-auto-select +${monitors.left.pos.x}+${monitors.left.pos.y} {rotation=right, ForceCompositionPipeline=On}, ${monitors.center.output}: nvidia-auto-select +${monitors.center.pos.x}+${monitors.center.pos.y} {AllowGSYNCCompatible=On}, ${monitors.right.output}: nvidia-auto-select +${monitors.right.pos.x}+${monitors.right.pos.y} {rotation=right, ForceCompositionPipeline=On}"
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
    ${monitors.left.output}: nvidia-auto-select +${monitors.left.pos.x}+${monitors.left.pos.y} {rotation=right, ForceCompositionPipeline=On}, \
    ${monitors.center.output}: nvidia-auto-select +${monitors.center.pos.x}+${monitors.center.pos.y} {AllowGSYNCCompatible=On}, \
    ${monitors.right.output}: nvidia-auto-select +${monitors.right.pos.x}+${monitors.right.pos.y} {rotation=right, ForceCompositionPipeline=On}"
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
    kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" "nvidia.hdmi_deepcolor=1" "amd_pstate=active" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = {
      "vm.overcommit_memory" = 1;
      #"net.ipv4.ip_forward" = 1; Overrode by Nixarr, which I think I want.
      #"net.ipv6.conf.all.forwarding" = 1;
    };
    supportedFilesystems = [ "ntfs" ];
  };


  #-------- POWER --------#
  powerManagement.enable = true;


  #-------- XDG PORTALS --------#
  xdg = {
    portal = {
      enable = true;
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
