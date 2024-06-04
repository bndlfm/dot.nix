{ config, pkgs, funkwhale, ... }:
let
  djangoSecretFile = pkgs.writeText "djangoSecret" "test123";
in {
  nixpkgs.overlays = [ funkwhale.overlay ];

  services = {
    fail2ban.enable = true;
    funkwhale = {
      enable = true;
      hostname = "placeholder";
      defaultFromEmail = "noreply@placeholder";
      protocol = "https";
      #forceSSL = false; # uncomment when LetsEncrypt needs to check "http:"
      api = {
        djangoSecretServiceKeyFile = "${djangoSecretFile}";
      };
    };
    nginx.clientMaxBodySize = "100m";
  };
  security.acme = {
    email = "placeholder";
    acceptTerms = true;
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
