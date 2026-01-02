{ config, ... }:
{
  sops = {
    defaultSopsFile = ../sops/secrets.home.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/home/neko/.config/sops/age/keys.txt";

    secrets = {
      "ai_keys/ANTHROPIC_API_KEY" = {};
      "ai_keys/GEMINI_SECRET_KEY" = {};
      "ai_keys/GROQ_SECRET_KEY" = {};
      "ai_keys/HUGGINGFACE_API_KEY" = {};
      "ai_keys/HUGGINGFACE_PASSWD" = {};

      "internet/DUCKDNS_TOKEN" = {};
      "internet/GMAIL_APP_PASS" = {};
      "internet/lastfm_pass" = {};
      "internet/TWITCH_IRC_OAUTH" = {};

      "local/OBSIDIAN_REST_API_KEY" = {};
    };
    templates = {
      "session-secrets" = {
        content = ''
          ANTHROPIC_API_KEY = ${config.sops.placeholder."ai_keys/ANTHROPIC_API_KEY"}
          GEMINI_SECRET_KEY = ${config.sops.placeholder."ai_keys/GEMINI_SECRET_KEY"}
          GROQ_SECRET_KEY = ${config.sops.placeholder."ai_keys/GROQ_SECRET_KEY"}
          HUGGINGFACE_API_KEY = ${config.sops.placeholder."ai_keys/HUGGINGFACE_API_KEY"}
          HUGGINGFACE_PASSWD = ${config.sops.placeholder."ai_keys/HUGGINGFACE_PASSWD"}

          DUCKDNS_TOKEN = ${config.sops.placeholder."internet/DUCKDNS_TOKEN"}
          GMAIL_APP_PASS = ${config.sops.placeholder."internet/GMAIL_APP_PASS"}
          TWITCH_IRC_OAUTH = ${config.sops.placeholder."internet/TWITCH_IRC_OAUTH"}

          OBSIDIAN_REST_API_KEY = ${config.sops.placeholder."local/OBSIDIAN_REST_API_KEY"}
        '';
      };
    };
  };
}
