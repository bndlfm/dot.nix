{ ... }:{
  nixarr = {
    enable = true;
    # These two values are also the default, but you can set them to whatever
    # else you want
    #WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
      #mediaDir = "/media/content/";
      #stateDir = "/media/.state/nixarr";
    vpn = {
      enable = true;
      # WARNING: This file must _not_ be in the config git directory
      # You can usually get this wireguard file from your VPN provider
      wgConf = "/data/.secret/vpn/airvpn_sweden.conf";
    };
    jellyfin = {
      enable = true;
    };
    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 37285; # Set this to the port forwarded by your VPN
    };
    bazarr.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;
  };

  services = {
    caddy.virtualHosts = {
      "http://jellyfin.munchkin-sun.ts.net".extraConfig =
          ''
              bind tailscale/jellyfin
              reverse_proxy localhost:8096
              tls {
                  get_certificate tailscale
              }
          '';
      "http://jellyseerr.munchkin-sun.ts.net".extraConfig =
          ''
              bind tailscale/jellyseerr
              reverse_proxy localhost:5055
              tls {
                  get_certificate tailscale
              }
          '';
    };
    flaresolverr.enable = true;
    jellyseerr = {
      enable = true;
      openFirewall = true;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
        8096 # Jellyfin HTTP
        8920 # Jellyfin HTTPS
        37285 # Nixarr AirVPN Torrenting
    ];
    allowedUDPPorts = [
        1900
        7359 # Jellyfin service autodiscovery
        37285 # Nixarr AirVPN Torrenting
    ];
  };
}
