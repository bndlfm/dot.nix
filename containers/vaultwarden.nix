{ config, lib, ...}:
let
  _g = import ../lib/globals.nix { inherit config; };
in {
  #  networking.nat = {
  #    enable = true;
  #    enableIPv6 = true;
  #    internalInterfaces = [ "ve-+" ];
  #    externalInterface = _g.defaultNetInterface;
  #  };

  containers.vaultwarden = {
    autoStart = true;

    #privateNetwork = true;
    #hostAddress = "192.168.100.10";
    #localAddress = "192.168.100.11";
    #hostAddress6 = "fc00::1";
    #localAddress6 = "fc00::2";

    bindMounts = {
      "/.vaultwarden" = {
        hostPath = "/mnt/data/.vaultwarden";
        isReadOnly = false;
      };
    };

    config = { ... }: {
      networking = {
        firewall.allowedTCPPorts = [ 8222 ];
        #useHostResolvConf = lib.mkForce false;
      };
      services.vaultwarden = {
        enable = true;
        backupDir = "/.vaultwarden";
        config = {
          ROCKET_ADDRESS = "0.0.0.0";
          ROCKET_PORT = "8222";
        };
      };
    };
  };

  services.caddy.virtualHosts."https://vault.munchkin-sun.ts.net".extraConfig =
    ''
      bind tailscale/vault:443
      reverse_proxy localhost:8222
    '';

}
