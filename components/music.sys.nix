{ config, pkgs, ...}:
{
  services.mympd = {
    enable = true;
    openFirewall = true;
    settings = {
      http_port = 8742;
    };
  };

  # Open the port in the firewall
  networking.firewall.allowedTCPPorts = [ 8742 ];
}
