{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  sops.secrets."internet/CADDY_TS_AUTHKEY" = { };

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
    networkmanager.dispatcherScripts = [
      {
        source = pkgs.writeText "tailscale-ethtool" ''
          #!/bin/sh
          if [ "$1" = "enp6s0" ] && [ "$2" = "up" ]; then
            ${pkgs.lib.getExe pkgs.ethtool} -K enp6s0 rx-udp-gro-forwarding on rx-gro-list off
            echo "Tailscale ethtool udp-gro-forwarding on!"
          fi
        '';
        type = "basic";
      }
    ];
  };

  services = {
    caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/tailscale/caddy-tailscale@v0.0.0-20250207163903-69a970c84556"
          "github.com/jasonlovesdoggo/caddy-defender@v0.8.5"
        ];
        hash = "sha256-CmbwwDMruT5AWdA+0wWWXfQD4kLZGvKUB/oTs2XBoAg=";
      };

      virtualHosts."homeassistant.munchkin-sun.ts.net".extraConfig = ''
        bind tailscale/homeassistant:443
        reverse_proxy localhost:8123
      '';
    };
    tailscale = {
      enable = true;
      openFirewall = true;
      permitCertUid = "caddy";
      useRoutingFeatures = "client";
    };
  };

  systemd.services.caddy.serviceConfig = lib.mkIf config.services.caddy.enable {
    EnvironmentFile = config.sops.secrets."internet/CADDY_TS_AUTHKEY".path;
    StateDirectory = "caddy";
  };
}
