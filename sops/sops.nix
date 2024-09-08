{pkgs, inputs, config, ... }:
{
  sops.defaultSopsFile = "../secrets/secrets.yaml";
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/neko/.config/sops/age/key.txt";
  sops.secrets."myservice/my_subdir/my_secret" = {};
}
