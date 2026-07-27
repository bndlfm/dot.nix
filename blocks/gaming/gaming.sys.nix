{ inputs, pkgs, ... }:
let
  gameuser = "neko";
in
{

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
        _proton-ge-rtsp
        _dwproton
        gamescope
      ];
    };
  };

  services = {
    udev = {
      packages = with pkgs; [
        game-devices-udev-rules
      ];
    };
  };

  users.users.${gameuser} = {
    extraGroups = [ "gamemode" ];
  };
}
