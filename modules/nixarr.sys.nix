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
      # These options set up a nginx HTTPS reverse proxy, so you can access
      # Jellyfin on your domain with HTTPS
      expose.https = {
        enable = false;
        domainName = "your.domain.com";
        acmeMail = "your@email.com"; # Required for ACME-bot
      };
    };

    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 37285; # Set this to the port forwarded by your VPN
    };

    # It is possible for this module to run the *Arrs through a VPN, but it
    # is generally not recommended, as it can cause rate-limiting issues.
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
          bind tailscale/jellyfin:80
          reverse_proxy localhost:8096
        '';
      "https://jellyfin.munchkin-sun.ts.net".extraConfig =
        ''
          bind tailscale/jellyfin:443
          reverse_proxy localhost:8920
          tls {
            get_certificate tailscale
          }
        '';
    };
    flaresolverr.enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      8096 # Jellyfin HTTP
      8920 # Jellyfin HTTPS
      37285 # Nixarr AirVPN Torrenting
    ];
    allowedUDPPorts = [
      1900 7359 # Jellyfin service autodiscovery
      37285 # Nixarr AirVPN Torrenting
    ];
  };
}
