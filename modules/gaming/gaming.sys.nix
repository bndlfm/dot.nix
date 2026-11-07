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
        oversteer
      ];

      # The upstream TrueForce rule checks /usr/bin/logi-wheel-modeswitch,
      # but the NixOS module installs it in the system profile instead.
      # Dispatch the packaged helper asynchronously so the Xbox G923 can
      # leave console mode before HID probes run.
      extraRules = ''
        ACTION!="add|change", GOTO="g923_nixos_modeswitch_end"
        SUBSYSTEM!="usb", GOTO="g923_nixos_modeswitch_end"
        ATTR{idVendor}=="046d", ATTR{idProduct}=="c26d", RUN+="${pkgs.runtimeShell} -c 'systemd-run --no-block --collect --description=logitech-g923-modeswitch /run/current-system/sw/bin/logi-wheel-modeswitch >/dev/null 2>&1'"
        LABEL="g923_nixos_modeswitch_end"
      '';
    };
  };

  hardware.logitech-trueforce.enable = true;

  users.users.${gameuser} = {
    extraGroups = [ "gamemode" ];
  };
}
