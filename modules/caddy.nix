{
  config,
  pkgs,
  ...
}:{
  environment.systemPackages = with pkgs; [
    ethtool
    tailscale
    networkd-dispatcher
  ];


  networking = {
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
    };
    interfaces."tailscale0" = {
      useDHCP = false;
      wakeOnLan.enable = true;
    };
  };


  services = {
    caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins
        {
          plugins = [ "github.com/tailscale/caddy-tailscale@v0.0.0-20250207163903-69a970c84556" ];
          hash = "sha256-mGJcpvs3XqW5UNUkIADdz/poyr96cq+SzCFdKyWdMKY=";
        };
      virtualHosts = {
        "https://jellyfin.munchkin-sun.ts.net".extraConfig =
          ''
            bind tailscale/jellyfin:80
            reverse_proxy localhost:8096
          '';
        "https://vault.munchkin-sun.ts.net".extraConfig =
          ''
            bind tailscale/vault:443
            reverse_proxy localhost:8222
          '';
      };
    };
    networkd-dispatcher = {
      enable = true;
      rules = {
        "50-tailscale" = {
          onState = ["routable"];
          script =
            ''
              ${pkgs.lib.getExe pkgs.ethtool} -K enp6s0 rx-udp-gro-forwarding on rx-gro-list off
            '';
        };
      };
    };
    tailscale = {
      enable = true;
      openFirewall = true;
    };
  };

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = config.sops.secrets.TS_AUTHKEY.path;
  };
}
