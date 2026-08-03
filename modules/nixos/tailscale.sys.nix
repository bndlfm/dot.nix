{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tailscale
    trayscale
  ];

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "client";
  };
}
