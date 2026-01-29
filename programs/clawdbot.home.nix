{ config, pkgs, ... }:{
  home.packages = with pkgs; [
    _obsidian-cli
    _gifgrep
    _bird
    _blogwatcher
    _goplaces
    _mcporter
    _songsee
    _spogo
    _summarize
    _sag
    _nano-pdf
    _camsnap
    _gogcli
    himalaya
    tmux
    curl
    openai-whisper
    uv
  ];
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
      #{ source = "path:./pkgs/moltbot/plugins/steipete-tools/camsnap"; }
      #{ source = "path:./pkgs/moltbot/plugins/steipete-tools/gogcli"; }
      #{ source = "path:./pkgs/moltbot/plugins/steipete-tools/summarize"; }
      #{ source = "path:./pkgs/moltbot/plugins/steipete-tools/sag"; }
      #{ source = "path:./pkgs/moltbot/plugins/steipete-tools/oracle"; }
    ];
  };
}
