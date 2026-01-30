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
    _mcp-arr
    himalaya
    tmux
    curl
    openai-whisper
    uv
  ];
  programs.moltbot = {
    enable = true;
    manageConfig = false;

    exposePluginPackages = false;

    firstParty = {
      summarize.enable = false;
      peekaboo.enable = false;
    };

    instances = {
      default = {
        enable = true;
        package = pkgs._moltbot;

        stateDir = "${config.home.homeDirectory}/.moltbot";
        workspaceDir = "${config.home.homeDirectory}/.moltbot/workspace";

        config.channels.discord.accounts.default = {
          enabled = true;
          token = builtins.readFile config.sops.secrets."discord/clawdbot".path;
          intents = { guildMembers = true; presence = true; };
          guilds."1465431090817663094".requireMention = true;
        };
      };
    };
    providers.anthropic = {
      apiKeyFile = config.sops.secrets."ai_keys/ANTHROPIC_API_KEY".path;
    };

    # Built-ins (tools + skills) shipped via nix-steipete-tools.
    plugins = [
    ];
  };
}
