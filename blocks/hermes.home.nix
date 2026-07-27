{ config, pkgs, ... }: {

  sops = {
    defaultSopsFile = ../sops/secrets.home.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
    };

    templates."hermes.env".content = "";
  };

  home.packages = with pkgs; [ google-cloud-sdk ];

  services.hermes-agent = {
    enable = true;
    environmentFiles = [ config.sops.secrets."hermes.env".path ];
    settings = {
      model = {
        default = "google-code-assist";
        provider = "google-code-assist";
        contextLength = 1000000;
      };
      toolsets = [ "all" ];
      max_turns = 100;
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
}
