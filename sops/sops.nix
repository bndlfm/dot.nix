{ config, ... }:
{
  sops = {
      defaultSopsFile = ../sops/secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = "/home/neko/.config/sops/age/keys.txt";

      secrets = {
          "ai_keys/ANTHROPIC_API_KEY" = {};
          "ai_keys/GEMINI_SECRET_KEY" = {};
          "ai_keys/GROQ_SECRET_KEY" = {};
          "ai_keys/HUGGINGFACE_API_KEY" = {};
          "ai_keys/HUGGINGFACE_PASSWD" = {};

          "services/CADDY_TS_AUTHKEY" = {};
          "services/DUCKDNS_TOKEN" = {};
          "services/GMAIL_APP_PASS" = {};
          "services/OBSIDIAN_REST_API_KEY" = {};
          "services/TWITCH_IRC_OAUTH" = {};
      };

      templates."session-secrets" = {
          content = ''
              ANTHROPIC_API_KEY = ${config.sops.placeholder."ai_keys/ANTHROPIC_API_KEY"}
              GEMINI_SECRET_KEY = ${config.sops.placeholder."ai_keys/GEMINI_SECRET_KEY"}
              GROQ_SECRET_KEY = ${config.sops.placeholder."ai_keys/GROQ_SECRET_KEY"}
              HUGGINGFACE_API_KEY = ${config.sops.placeholder."ai_keys/HUGGINGFACE_API_KEY"}
              HUGGINGFACE_PASSWD = ${config.sops.placeholder."ai_keys/HUGGINGFACE_PASSWD"}

              DUCKDNS_TOKEN = ${config.sops.placeholder."services/DUCKDNS_TOKEN"}
              GMAIL_APP_PASS = ${config.sops.placeholder."services/GMAIL_APP_PASS"}
              OBSIDIAN_REST_API_KEY = ${config.sops.placeholder."services/OBSIDIAN_REST_API_KEY"}
              TWITCH_IRC_OAUTH = ${config.sops.placeholder."services/TWITCH_IRC_OAUTH"}
          '';
      };
  };
}
