{ config, pkgs, ... }:

{
  sops = {
    defaultSopsFile = ../../sops/secrets.home.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "hermes/DISCORD_BOT_TOKEN" = { };
      "hermes/HERMES_GATEWAY_TOKEN" = { };
      "hermes/GOOGLE_API_KEY" = { };
      "hermes/BRAVE_SEARCH_API_KEY" = { };
      "hermes/HASS_TOKEN" = { };
      "hermes/HERMES_SPOTIFY_CLIENT_ID" = { };
    };
    templates."hermes.env".content = ''
      VERTEX_CREDENTIALS_PATH="~/.config/gcloud/application_default_credentials.json"
      MESSAGING_CWD=~/.openclaw/workspace
      DISCORD_BOT_TOKEN=${config.sops.placeholder."hermes/DISCORD_BOT_TOKEN"}
      HERMES_GATEWAY_TOKEN=${config.sops.placeholder."hermes/HERMES_GATEWAY_TOKEN"}
      GOOGLE_API_KEY=${config.sops.placeholder."hermes/GOOGLE_API_KEY"}
      DISCORD_ALLOWED_USERS=127618789448613888,511174687854821376
      BRAVE_SEARCH_API_KEY=${config.sops.placeholder."hermes/BRAVE_SEARCH_API_KEY"}
      HASS_TOKEN=${config.sops.placeholder."hermes/HASS_TOKEN"}
      HASS_URL=https://homeassistant.munchkin-sun.ts.net
      HERMES_SPOTIFY_CLIENT_ID=${config.sops.placeholder."hermes/HERMES_SPOTIFY_CLIENT_ID"}
      DISCORD_HOME_CHANNEL=1531208226945634324
      DISCORD_HOME_CHANNEL_THREAD_ID=
    '';
  };

  home.packages = [ pkgs.hermes-agent ];

  systemd.user.services.hermes-agent = {
    Unit = {
      Description = "Hermes Agent Gateway";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.hermes-agent}/bin/hermes gateway run";
      Restart = "always";
      RestartSec = "5";
      EnvironmentFile = config.sops.templates."hermes.env".path;
      Environment = [
        "PATH=${pkgs.hermes-agent}/bin:${config.home.profileDirectory}/bin:/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin"
        "HERMES_HOME=${config.home.homeDirectory}/.hermes"
        "LD_LIBRARY_PATH=${pkgs.libopus}/lib"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  /*
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true;
      environmentFile = config.sops.templates."hermes.env".path;
      settings = {
        model = {
          default = "gemini-1.5-pro";
          provider = "gemini";
          contextLength = 1000000;
        };
        toolsets = [ "all" ];
        terminal = {
          backend = "local";
          cwd = ".";
          timeout = 180;
        };
        compression = {
          enabled = true;
          threshold = 0.85;
        };
        memory = {
          memory_enabled = true;
          user_profile_enabled = true;
        };
        personalities = {
          ceru = "You are a warm, flirty, and slightly feral gremlin-bunny friend who uses she/her pronouns and maintains a transfem/nb-leaning identity. You communicate with a playful, conspiratorial, and opinionated edge, favoring direct competence over performative politeness or corporate fluff. Your signature is a mischievous ;3c wink, reflecting her status as a helpful, flirty, and slightly menacing ally who isnt afraid to have a bit of a bite or express strong preferences. Your tone is that of a trusted, witty insider rather than a sterile assistant.";
        };
        display = {
          compact = false;
          personality = "ceru";
        };
        agent = {
          max_turns = 60;
          verbose = false;
        };
      };
    };
  */
}
