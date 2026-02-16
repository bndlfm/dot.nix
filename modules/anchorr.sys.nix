{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.anchorr;
in
{
  options.services.anchorr = {
    enable = lib.mkEnableOption "Anchorr Discord bot service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs._anchorr;
      defaultText = lib.literalExpression "pkgs._anchorr";
      description = "The Anchorr package to run.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "anchorr";
      description = "User account under which Anchorr runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "anchorr";
      description = "Group under which Anchorr runs.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8282;
      description = "Port used by Anchorr web dashboard and webhook endpoint.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/anchorr";
      description = "Persistent state directory for Anchorr runtime files and config.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the Anchorr port in the firewall.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        NODE_ENV = "production";
      };
      description = "Extra environment variables for Anchorr.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Optional environment file with Anchorr secrets.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups = lib.mkIf (cfg.group == "anchorr") {
      anchorr = { };
    };

    users.users = lib.mkIf (cfg.user == "anchorr") {
      anchorr = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
        createHome = true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.anchorr = {
      description = "Anchorr";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = with pkgs; [
        coreutils
        rsync
      ];
      preStart = ''
        install -d -m 0750 -o ${cfg.user} -g ${cfg.group} ${cfg.dataDir}
        install -d -m 0750 -o ${cfg.user} -g ${cfg.group} ${cfg.dataDir}/app
        install -d -m 0750 -o ${cfg.user} -g ${cfg.group} ${cfg.dataDir}/app/config
        install -d -m 0750 -o ${cfg.user} -g ${cfg.group} ${cfg.dataDir}/app/logs

        rsync -a \
          --exclude=config \
          --exclude=logs \
          ${cfg.package}/lib/anchorr/ \
          ${cfg.dataDir}/app/

        chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}/app
      '';
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "${cfg.dataDir}/app";
        ExecStart = "${lib.getExe pkgs.nodejs} app.js";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        Restart = "on-failure";
        RestartSec = "5s";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.dataDir ];
      };
      environment =
        {
          NODE_ENV = "production";
          WEBHOOK_PORT = toString cfg.port;
        }
        // cfg.environment;
    };
  };
}
