{ sops-nix , ... }:
{

  sops = {
    defaultSopsFile = ../sops/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/neko/.config/sops/age/keys.txt";
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";

    secrets = {
      HUGGINGFACE_API_KEY = {
        format = "yaml";
        sopsFile = ./HUGGINGFACE_API_KEY.yaml;
      };

      OPENAI_API_KEY = {
        format = "yaml";
        sopsFile = ./secrets.yaml;
      };

      OBSIDIAN_REST_API_KEY = {
        format = "yaml";
        sopsFile = ./OBSIDIAN_REST_API_KEY.yaml;
      };
    };
  };

}
