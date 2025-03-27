{ ... }:
{

  sops = {
    defaultSopsFile = ../sops/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/neko/.config/sops/age/keys.txt";
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";

    secrets = {
      ANTHROPIC_API_KEY = {
        format = "yaml";
        sopsFile = ./ANTHROPIC_API_KEY.yaml;
      };

      DUCKDNS_TOKEN = {
        format = "yaml";
        sopsFile = ./DUCKDNS_TOKEN.yaml;
      };

      GMAIL_APP_PASS = {
        format = "yaml";
        sopsFile = ./GMAIL_APP_PASS.yaml;
      };

      GROQ_SECRET_KEY = {
        format = "yaml";
        sopsFile = ./GROQ_SECRET_KEY.yaml;
      };

      HUGGINGFACE_API_KEY = {
        format = "yaml";
        sopsFile = ./HUGGINGFACE_API_KEY.yaml;
      };

      HUGGINGFACE_PASSWD = {
        format = "yaml";
        sopsFile = ./HUGGINGFACE_PASSWD.yaml;
      };

      OPENAI_API_KEY = {
        format = "yaml";
        sopsFile = ./secrets.yaml;
      };

      OBSIDIAN_REST_API_KEY = {
        format = "yaml";
        sopsFile = ./OBSIDIAN_REST_API_KEY.yaml;
      };

      TWITCH_IRC_OAUTH = {
        format = "yaml";
        sopsFile = ./TWITCH_IRC_OAUTH.yaml;
      };
    };
  };
}
