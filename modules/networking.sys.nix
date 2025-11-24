{
  config,
  pkgs,
  ...
}:{
  environment.systemPackages = with pkgs; [
    ethtool
    tailscale
    trayscale
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
          hash = "sha256-cZWBui1q+DuzuerrM2CD6RAdtmp56cIwCPyfS1LchzI=";
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
      permitCertUid = "caddy";
    };
  };

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = config.sops.secrets.TS_AUTHKEY.path;
  };
}
