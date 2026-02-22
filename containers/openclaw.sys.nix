{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.openclawGateway;
in
{
  options.services.openclawGateway = {
    enable = lib.mkEnableOption "Declarative NixOS container for OpenClaw gateway";

    user = lib.mkOption {
      type = lib.types.str;
      default = "neko";
      description = "User to run OpenClaw gateway inside the container.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "neko";
      description = "Group for the OpenClaw gateway user inside the container.";
    };

    uid = lib.mkOption {
      type = lib.types.int;
      default = 1000;
      description = "UID for the OpenClaw gateway user inside the container.";
    };

    gid = lib.mkOption {
      type = lib.types.int;
      default = 1000;
      description = "GID for the OpenClaw gateway group inside the container.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 18789;
      description = "OpenClaw gateway port.";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "25.11";
      description = "State version for the container system.";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to auto-start the openclaw-gateway container at boot.";
    };
  };

  config = lib.mkIf cfg.enable {
    containers."openclaw-gateway" = {
      autoStart = cfg.autoStart;

      bindMounts = {
        "/nix/store" = {
          hostPath = "/nix/store";
          isReadOnly = true;
        };
        "/nix/var/nix/db" = {
          hostPath = "/nix/var/nix/db";
          isReadOnly = true;
        };
        "/nix/var/nix/daemon-socket" = {
          hostPath = "/nix/var/nix/daemon-socket";
          isReadOnly = false;
        };
        "/home/${cfg.user}/.openclaw" = {
          hostPath = "/home/${cfg.user}/.openclaw";
          isReadOnly = false;
        };
        "/home/${cfg.user}/.clawdbot" = {
          hostPath = "/home/${cfg.user}/.clawdbot";
          isReadOnly = false;
        };
        "/home/${cfg.user}/Notes" = {
          hostPath = "/home/${cfg.user}/Notes";
          isReadOnly = false;
        };
        "/home/${cfg.user}/.nixcfg" = {
          hostPath = "/home/${cfg.user}/.nixcfg";
          isReadOnly = false;
        };
        "/home/${cfg.user}/.config/gogcli" = {
          hostPath = "/home/${cfg.user}/.config/gogcli";
          isReadOnly = false;
        };
      };

      config =
        { ... }:
        {
          nix.package = pkgs.nix;
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          users.groups.${cfg.group} = {
            gid = cfg.gid;
          };

          users.users.${cfg.user} = {
            isNormalUser = true;
            uid = cfg.uid;
            group = cfg.group;
            home = "/home/${cfg.user}";
            createHome = true;
          };

          environment.systemPackages = with pkgs; [
            nix
            git
            cacert
          ];

          systemd.services.openclaw-gateway = {
            description = "OpenClaw Gateway";
            wantedBy = [ "multi-user.target" ];
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            serviceConfig = {
              Type = "simple";
              User = cfg.user;
              Group = cfg.group;
              WorkingDirectory = "/home/${cfg.user}";
              Restart = "on-failure";
              Environment = [
                "HOME=/home/${cfg.user}"
                "XDG_CONFIG_HOME=/home/${cfg.user}/.config"
                "XDG_STATE_HOME=/home/${cfg.user}/.local/state"
                "NVIDIA_VISIBLE_DEVICES=all"
                "NVIDIA_DRIVER_CAPABILITIES=all"
              ];
              ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/${cfg.user}/.config /home/${cfg.user}/.local/state /home/${cfg.user}/Notes /home/${cfg.user}/.nixcfg /home/${cfg.user}/.openclaw /home/${cfg.user}/.clawdbot";
              ExecStart = "${pkgs._openclaw}/bin/openclaw gateway --bind loopback --port ${toString cfg.port}";
            };
          };

          system.stateVersion = cfg.stateVersion;
        };
    };
  };
}
