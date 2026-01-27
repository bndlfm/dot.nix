{ config, pkgs, ... }:{
  programs.clawdbot = {
    enable = true;
    exposePluginPackages = false;
    #documents = "${builtins.getEnv "HOME"}/Documents";
    firstParty = {
      summarize.enable = false;
      peekaboo.enable = false;
    };
    instances = {
      default = {
        enable = true;
        package = pkgs._moltbot;
        manageConfig = false;

        gatewayAuthTokenFile = config.sops.secrets."local/CLAWDBOT_GATEWAY_TOKEN".path;

        stateDir = "~/.clawdbot";
        workspaceDir = "~/.clawdbot/workspace";

        providers.discord = {
          enable = true;
          tokenFile = config.sops.secrets."discord/clawdbot".path;
          accountConfig = {
            # Optional examples:
            intents = { guildMembers = true; presence = true; };
            guilds."1465431090817663094".requireMention = true;
          };
        };
      };
    };
    providers.anthropic = {
      apiKeyFile = config.sops.secrets."ai_keys/ANTHROPIC_API_KEY".path;
    };

    # Built-ins (tools + skills) shipped via nix-steipete-tools.
    plugins = [
      { source = "github:clawdbot/nix-steipete-tools?dir=tools/camsnap"; }
      { source = "github:clawdbot/nix-steipete-tools?dir=tools/gogcli"; }
      { source = "github:clawdbot/nix-steipete-tools?dir=tools/summarize"; }
      { source = "github:clawdbot/nix-steipete-tools?dir=tools/sag"; }
      { source = "github:clawdbot/nix-steipete-tools?dir=tools/oracle"; }
    ];
  };
}
