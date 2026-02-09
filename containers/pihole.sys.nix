{ pkgs, ... }:
let
  piholeIPv4 = "192.168.1.200";
in
{
  networking = {
    nameservers = [ piholeIPv4 ];
    networkmanager.insertNameservers = [ piholeIPv4 ];
    firewall = {
      allowedTCPPorts = [
        53 # DNS DUH
        8053
      ];
      allowedUDPPorts = [
        53 # DNS DUH
      ];
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.pihole = {
      image = "docker.io/pihole/pihole:latest";
      volumes = [
        "pihole:/etc/pihole"
        "dnsmasq:/etc/dnsmasq.d"
      ];
      extraOptions = [
        "--network=pihole-macvlan"
        "--ip=${piholeIPv4}"
      ];
      environment = {
        TZ = "America/Chicago";
        WEB_PORT = "8053";
        DNSMASQ_LISTENING = "all";
      };
    };
  };

  systemd.services.pihole-macvlan-network = {
    description = "Create Podman macvlan network for Pi-hole";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network-online.target"
      "NetworkManager-wait-online.service"
    ];
    wants = [
      "network-online.target"
      "NetworkManager-wait-online.service"
    ];
    before = [ "podman-pihole.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      set -eu
      iface=""
      for _ in $(seq 1 30); do
        iface="$(${pkgs.iproute2}/bin/ip -4 route list default | ${pkgs.gawk}/bin/awk '{print $5; exit}')"
        [ -n "$iface" ] && break
        sleep 1
      done
      if [ -z "$iface" ]; then
        echo "Could not determine default network interface for macvlan parent"
        exit 1
      fi

      if ! ${pkgs.podman}/bin/podman network exists pihole-macvlan; then
        ${pkgs.podman}/bin/podman network create \
          --driver macvlan \
          --subnet 192.168.1.0/24 \
          --gateway 192.168.1.1 \
          -o parent="$iface" \
          pihole-macvlan
      fi
    '';
  };

  systemd.services.pihole-macvlan-shim = {
    description = "Create host macvlan shim interface for Pi-hole reachability";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network-online.target"
      "NetworkManager-wait-online.service"
    ];
    wants = [
      "network-online.target"
      "NetworkManager-wait-online.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      set -eu
      iface=""
      for _ in $(seq 1 30); do
        iface="$(${pkgs.iproute2}/bin/ip -4 route list default | ${pkgs.gawk}/bin/awk '{print $5; exit}')"
        [ -n "$iface" ] && break
        sleep 1
      done
      if [ -z "$iface" ]; then
        echo "Could not determine default network interface for macvlan shim"
        exit 1
      fi

      if ! ${pkgs.iproute2}/bin/ip link show pihole-shim >/dev/null 2>&1; then
        ${pkgs.iproute2}/bin/ip link add pihole-shim link "$iface" type macvlan mode bridge
      fi

      if ! ${pkgs.iproute2}/bin/ip addr show dev pihole-shim | ${pkgs.gnugrep}/bin/grep -q "192.168.1.201/32"; then
        ${pkgs.iproute2}/bin/ip addr add 192.168.1.201/32 dev pihole-shim
      fi

      ${pkgs.iproute2}/bin/ip link set pihole-shim up

      # Force host-to-container traffic through the shim; "ip route show" exits 0
      # even when no matching route exists, so use replace unconditionally.
      ${pkgs.iproute2}/bin/ip route replace 192.168.1.200/32 dev pihole-shim
    '';
  };

  systemd.services.podman-pihole = {
    requires = [ "pihole-macvlan-network.service" ];
    after = [
      "pihole-macvlan-network.service"
      "pihole-macvlan-shim.service"
    ];
  };

  services.caddy.virtualHosts."pihole.munchkin-sun.ts.net".extraConfig = ''
    bind tailscale/pihole:443
    reverse_proxy ${piholeIPv4}:80
  '';
}
