{ config, ... }:
{
  sops = {
    defaultSopsFile = ../sops/secrets.sys.yaml;
    defaultSopsFormat = "yaml";

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "discord/ANCHORR_DISCORD_TOKEN" = { };
      "discord/ANCHORR_BOT_ID" = { };
      "discord/ANCHORR_GUILD_ID" = { };
    };

    templates."anchorr.env".content = ''
      DISCORD_TOKEN=${config.sops.placeholder."discord/ANCHORR_DISCORD_TOKEN"}
      DISCORD_BOT_ID=${config.sops.placeholder."discord/ANCHORR_BOT_ID"}
      DISCORD_GUILD_ID=${config.sops.placeholder."discord/ANCHORR_GUILD_ID"}
      TMDB_API_KEY=
      JELLYSEERR_API_KEY=
    '';
  };
  nixarr = {
    enable = true;
    # These two values are also the default, but you can set them to whatever
    # else you want
    #WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
    mediaDir = "/media/media/";
    stateDir = "/mnt/data/container_state";

    jellyfin = {
      enable = true;
    };
    plex = {
      enable = true;
      openFirewall = true;
    };

    anchorr = {
      enable = true;
      secretsFile = config.sops.templates."anchorr.env".path;
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
  };

  networking.firewall = {
    allowedTCPPorts = [
      8096 # Jellyfin HTTP
      8920 # Jellyfin HTTPS
      32400 # Plex
      37285 # Nixarr AirVPN Torrenting
      8282 # Anchorr
    ];
    allowedUDPPorts = [
      1900
      7359 # Jellyfin service autodiscovery
      37285 # Nixarr AirVPN Torrenting
    ];
  };
}
