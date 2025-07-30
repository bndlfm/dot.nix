#
# jovian.nix -- Gaming
#
{inputs, pkgs, ...}: let
  # Local user account for auto login
  # Separate and distinct from Steam login
  # Can be any name you like
  gameuser = "gamer";
in {
  imports = [ inputs.jovian-nixos.nixosModules.default ];

  system.activationScripts = {
    print-jovian = {
      text = builtins.trace "building the jovian configuration..." "";
    };
  };

  #
  # Boot
  #
  boot.kernelParams = ["amd_pstate=active"];

  #
  # Jovian
  #
  jovian = {
    decky-loader = {
      enable = true;
    };
    hardware.has.amd.gpu = false;
  };

  #
  # Packages
  #
  environment.systemPackages = with pkgs; [
    cmake # Cross-platform, open-source build system generator
    steam-rom-manager # App for adding 3rd party games/ROMs as Steam launch items
  ];

  #
  # SDDM
  #
  services.displayManager.sddm.settings = {
    Autologin = {
      Session = "gamescope-wayland.desktop";
      User = "${gameuser}";
    };
  };

  #
  # Steam
  #
  # Set game launcher: gamemoderun %command%
  #   Set this for each game in Steam, if the game could benefit from a minor
  #   performance tweak: YOUR_GAME > Properties > General > Launch > Options
  #   It's a modest tweak that may not be needed. Jovian is optimized for
  #   high performance by default.
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
        /*gpu = {
          apply_gpu_optimisations = "accept-responsibility"; # For systems with AMD GPUs
          gpu_device = 0;
          amd_performance_level = "high";
        };*/
    };
  };

  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession = {
      enable = true;
      env = {
        PROTON_ENABLE_NVAPI = "1";
        PROTON_HIDE_NVIDIA_GPU = "0";
        VKD3D_CONFIG = "dxr";
        VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
        MANGO_HUD = "1";
      };
    };
    remotePlay.openFirewall = true;

    extraCompatPackages = with pkgs; [
      _proton-ge-rtsp
      proton-ge-bin
      gamescope
    ];
  };

  #
  # Users
  #
  users = {
    groups.${gameuser} = {
      name = "${gameuser}";
      gid = 10000;
    };

    # Generate hashed password: mkpasswd -m sha-512
    # hashedPassword sets the initial password. Use `passwd` to change it.
    users.${gameuser} = {
      description = "${gameuser}";
      extraGroups = ["gamemode" "networkmanager"];
      group = "${gameuser}";
      hashedPassword = "$y$j9T$MinUPdEcVb5i8sqCAUCR2/$Y9m2V3TUVxcaY0E33rvJ0P.Ed.dKk4PZJKnyOk/i46C";
      home = "/home/${gameuser}";
      isNormalUser = true;
      uid = 10000;
    };
  };
}
