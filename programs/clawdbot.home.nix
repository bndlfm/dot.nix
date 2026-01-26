{ config, pkgs, ... }:{

  sops.secrets."discord/clawdbot" = {};

  programs.clawdbot = {
    enable = true;
    #documents = "${builtins.getEnv "HOME"}/Documents";
    instances.default = {
      enable = true;
      package = pkgs._clawdbot;
      stateDir = "${builtins.getEnv "HOME"}/.clawdbot";
      workspaceDir = "${builtins.getEnv "HOME"}/.clawdbot/workspace";

      providers.discord = {
        enable = true;
        tokenFile = config.sops.secrets."discord/clawdbot".path;
        accountConfig = {
          # Optional examples:
          # intents = { guildMembers = true; presence = true; };
          # guilds."123456789012345678".requireMention = true;
        };
      };
    };
    providers.anthropic = {
      apiKeyFile = config.sops.secret."ai_keys/ANTHROPIC_API_KEY".path;
    };

    # Built-ins (tools + skills) shipped via nix-steipete-tools.
    plugins = [
    ];
  };
}
