{ config, ... }:

{
  sops = {
    defaultSopsFile = ../sops/secrets.home.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/home/neko/.config/sops/age/keys.txt";

    secrets = {
      "local/gluetun_private_key" = { };
      "local/gluetun_preshared_key" = { };
      "local/gluetun_addresses" = { };
    };

    templates."gluetun.env".content = ''
      WIREGUARD_PRIVATE_KEY=${config.sops.placeholder."local/gluetun_private_key"}
      WIREGUARD_PRESHARED_KEY=${config.sops.placeholder."local/gluetun_preshared_key"}
      WIREGUARD_ADDRESSES=${config.sops.placeholder."local/gluetun_addresses"}
    '';
  };

  services.podman.containers.gluetun = {
    image = "qmcgaw/gluetun";
    autoStart = true;
    addCapabilities = [
      "NET_ADMIN"
      "NET_RAW"
    ];
    extraPodmanArgs = [
      "--device=/dev/net/tun:/dev/net/tun"
    ];

    environmentFile = [ "${config.sops.templates."gluetun.env".path}" ];

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
}
