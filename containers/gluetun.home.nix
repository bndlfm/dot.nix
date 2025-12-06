{ config, inputs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = ../sops/secrets.sys.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."local/gluetun_private_key" = {};
  sops.secrets."local/gluetun_preshared_key" = {};
  sops.secrets."local/gluetun_addresses" = {};

  sops.templates."gluetun.env".content = ''
    WIREGUARD_PRIVATE_KEY=${config.sops.placeholder."local/gluetun_private_key"}
    WIREGUARD_PRESHARED_KEY=${config.sops.placeholder."local/gluetun_preshared_key"}
    WIREGUARD_ADDRESSES=${config.sops.placeholder."local/gluetun_addresses"}
  '';

  virtualisation.oci-containers.containers.gluetun = {
    image = "qmcgaw/gluetun";
    autoStart = true;
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=NET_RAW"
      "--device=/dev/net/tun:/dev/net/tun"
    ];

    environmentFiles = [ config.sops.templates."gluetun.env".path ];

    environment = {
      VPN_SERVICE_PROVIDER = "airvpn";
      VPN_TYPE = "wireguard";
      SERVER_COUNTRIES = "Canada";

      HTTPPROXY = "on";
      FIREWALL_OUTBOUND_SUBNETS = "192.168.1.0/24";
    };

    ports = [
      "8888:8888/tcp"
      "8388:8388/tcp"
      "8388:8388/udp"
    ];
  };
  networking.firewall = {
    allowedTCPPorts = [
      8388
      8888
    ];
    allowedUDPPorts = [
      8388
    ];
  };
}
