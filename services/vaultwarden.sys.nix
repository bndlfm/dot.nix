{...}:{
  networking.firewall.allowedTCPPorts = [ 8222 ];

  services.vaultwarden = {
    enable = true;
    backupDir = "/mnt/data/.vaultwarden";
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = "8222";
    };
  };

  services.caddy.virtualHosts."https://vault.munchkin-sun.ts.net".extraConfig =
    ''
      bind tailscale/vault:443
      reverse_proxy localhost:8222
    '';
}
