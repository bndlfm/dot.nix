{ sops-nix , ... }:
{
  sops.defaultSopsFile = ../sops/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/neko/.config/sops/age/keys.txt";
  sops.secrets."hyper-shell" = {};
}
