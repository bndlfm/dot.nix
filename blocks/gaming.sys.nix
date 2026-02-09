{ inputs, pkgs, ... }:
  let
    gameuser = "neko";
    jovianCfg = {
      boot.kernelParams = ["amd_pstate=active"];
      imports = [ inputs.jovian-nixos.nixosModules.default ];
      jovian = {
        steam = {
          enable = true;
          autoStart = false;
          desktopSession = "niri";
        };
        decky-loader = {
          enable = true;
        };
        hardware.has.amd.gpu = false;
      };
      users = {
        groups.${gameuser} = {
          name = "${gameuser}";
          gid = 10000;
        };
        /*
            NOTE: Generate hashed password: mkpasswd -m sha-512
                  hashedPassword sets the initial password.
                  >> Use `passwd` to change it.
        */
        users.${gameuser} = {
          description = "${gameuser}";
          extraGroups = ["gamemode" "networkmanager"];
          group = "${gameuser}";
          home = "/home/${gameuser}";
          isNormalUser = true;
          uid = 10000;
        };
      };
    };

  in {

    environment = {
      systemPackages = with pkgs; [
        cmake # Cross-platform, open-source build system generator
        steam-rom-manager # App for adding 3rd party games/ROMs as Steam launch items
      ];
      variables = {
      };
    };

    hardware.uinput.enable = true;

    programs = {
      gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 10;
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
          gpu = {
            #apply_gpu_optimisations = "accept-responsibility"; # For systems with AMD GPUs
            #gpu_device = 0;
            #amd_performance_level = "high";
          };
        };
      };
      steam = {
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
          #_proton-ge-rtsp
          gamescope
        ];
      };
    };


    services = {
      avahi = {
        enable = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };
      udev = {
        packages = with pkgs; [
          game-devices-udev-rules
        ];
      };
      wivrn = {
        enable = false;
        openFirewall = true;
        defaultRuntime = true; # Write information to /etc/xdg/openxr/1/active_runtime.json
        autoStart = true; # Run WiVRn as a systemd service on startup
        #package = (pkgs.wivrn.override { cudaSupport = true; }); # nVidia GPU support: not needed if systemwide cudaSupport = true;
      };
    };


    networking.firewall = {
      allowedUDPPorts = [
        5353
        9757
      ];
      allowedTCPPorts = [ 9757 ];
    };


    users.users.${gameuser} = {
      extraGroups = [ "gamemode" ];
    };
}
