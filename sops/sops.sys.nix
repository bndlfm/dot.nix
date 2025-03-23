{ ... }:
{

  sops = {
    defaultSopsFile = ../sops/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/neko/.config/sops/age/keys.txt";

    secrets = {
      TS_AUTHKEY = {
        format = "yaml";
        sopsFile = ./TS_AUTHKEY.yaml;
      };
    };
  };
}
