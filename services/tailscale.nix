{
  pkgs,
  ...
}:{
  environment.systemPackages = with pkgs; [ tailscale ];
  networking.firewall.allowedTCPPorts = [ 41641 ];
  services.tailscale = {
    enable = true;
    port = 41641;
  };
}
