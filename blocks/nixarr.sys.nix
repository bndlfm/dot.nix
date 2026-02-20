{ ... }:
{
  nixarr = {
    enable = true;
    # These two values are also the default, but you can set them to whatever
    # else you want
    #WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
    #mediaDir = "/media/content/";
    stateDir = "/mnt/data/container_state";

    jellyfin = {
      enable = true;
    };
    plex = {
      enable = true;
      openFirewall = true;
    };

    bazarr.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;

    vpn = {
      enable = true;
      # WARNING: This file must _not_ be in the config git directory
      # You can usually get this wireguard file from your VPN provider
      wgConf = "/media/.secret/vpn/airvpn_sweden.conf";
    };
    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 37285; # Set this to the port forwarded by your VPN
    };
  };

  services = {
    caddy.virtualHosts = {
      "jellyfin.munchkin-sun.ts.net".extraConfig = ''
        bind tailscale/jellyfin:443
        reverse_proxy localhost:8096
      '';
      "jellyseerr.munchkin-sun.ts.net".extraConfig = ''
        bind tailscale/jellyseerr:443
        reverse_proxy localhost:5055
      '';
    };
    flaresolverr.enable = true;
    jellyseerr = {
      enable = true;
      openFirewall = true;
    };

    # Anchorr: non-secret defaults here, secrets via sops-provisioned env file.
    anchorr = {
      enable = true;
      openFirewall = true;
      port = 8282;
      environmentFile = "/mnt/data/.secrets/anchorr/anchorr.env";
      environment = {
        AUTO_START_BOT = "true";
        JELLYSEERR_AUTO_APPROVE = "false";
        NOTIFY_ON_AVAILABLE = "true";
        PRIVATE_MESSAGE_MODE = "false";
        JELLYFIN_NOTIFY_MOVIES = "true";
        JELLYFIN_NOTIFY_SERIES = "false";
        JELLYFIN_NOTIFY_SEASONS = "false";
        JELLYFIN_NOTIFY_EPISODES = "true";
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      8096 # Jellyfin HTTP
      8920 # Jellyfin HTTPS
      32400 # Plex
      37285 # Nixarr AirVPN Torrenting
    ];
    allowedUDPPorts = [
      1900
      7359 # Jellyfin service autodiscovery
      37285 # Nixarr AirVPN Torrenting
    ];
  };
}
