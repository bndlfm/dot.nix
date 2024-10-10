{ sops-nix , ... }:
{
  sops = {
    defaultSopsFile = ../sops/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/neko/.config/sops/age/keys.txt";
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
    secrets.OPENAI_API_KEY = {
      format = "yaml";
      sopsFile = ./secrets.yaml;
      #path = "%r/OPENAI_API_KEY";
    };
  };
}
