{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hermes-agent;
  yamlFormat = pkgs.formats.yaml { };
in {
  options.services.hermes-agent = {
    enable = mkEnableOption "Hermes Agent Gateway service";

    package = mkOption {
      type = types.package;
      default = pkgs.hermes-agent;
      defaultText = literalExpression "pkgs.hermes-agent";
      description = "The hermes-agent package to use.";
    };

    settings = mkOption {
      type = yamlFormat.type;
      default = { };
      description = ''
        Configuration written to {file}`~/.hermes/config.yaml`.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/hermes-env";
      description = ''
        File containing environment variables (e.g. API keys).
        Passed to the systemd service.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file.".hermes/config.yaml" = mkIf (cfg.settings != { }) {
      source = yamlFormat.generate "hermes-config.yaml" cfg.settings;
    };

    systemd.user.services.hermes-agent = {
      Unit = {
        Description = "Hermes Agent Gateway";
        After = [ "network.target" ];
      };
      Service = {
        ExecStart = "${cfg.package}/bin/hermes gateway start";
        Restart = "on-failure";
        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
        Environment = "PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
