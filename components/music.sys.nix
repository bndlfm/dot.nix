{ config, pkgs, ...}:
{
  services.mympd = {
    enable = true;
    http_port = 8742;
    openFirewall = true;
  };

  # Open the port in the firewall
  networking.firewall.allowedTCPPorts = [ 8742 ];
}
