# Rootful Podman service for the bsdrX desktop agent.
# The system service is triggered when the user's Wayland session appears.
{ pkgs, ... }:
let
  bsdrx = pkgs._bsdrx;
  bsdrxImage = pkgs.dockerTools.buildLayeredImage {
    name = "bsdrx-agent";
    tag = "latest";
    contents = [ bsdrx pkgs.pulseaudio ];
    config.Entrypoint = [ "${bsdrx}/bin/bsdr_agent" ];
  };
  runBsdrx = pkgs.writeShellScript "run-bsdrx-agent" ''
    set -eu
    ${pkgs.podman}/bin/podman load --input ${bsdrxImage}
    install -d -o 1000 -g 100 /home/neko/.local/share/bsdrX
    for attempt in $(${pkgs.coreutils}/bin/seq 1 60); do
      if ${pkgs.iproute2}/bin/ip -o -4 address show dev enp6s0 \
        | ${pkgs.gnugrep}/bin/grep -q '192\.168\.1\.247/24'; then
        break
      fi
      ${pkgs.coreutils}/bin/sleep 1
    done
    ${pkgs.iproute2}/bin/ip -o -4 address show dev enp6s0 \
      | ${pkgs.gnugrep}/bin/grep -q '192\.168\.1\.247/24' || {
        echo "bsdrX LAN address 192.168.1.247 is not configured on enp6s0" >&2
        exit 1
      }
    exec ${pkgs.podman}/bin/podman run \
      --name bsdrx-agent \
      --replace \
      --rm \
      --network bridge \
      --runtime ${pkgs.crun}/bin/crun \
      --user 1000:100 \
      --group-add keep-groups \
      --workdir /var/lib/bsdrX \
      --publish 127.0.0.1:18088:8088/tcp \
      --publish 192.168.1.247:8088:8088/tcp \
      --publish 192.168.1.247:45678:45678/tcp \
      --publish 192.168.1.247:45000:45000/udp \
      --publish 192.168.1.247:45002:45002/udp \
      --publish 192.168.1.247:45003:45003/udp \
      --publish 192.168.1.247:45004:45004/udp \
      --device /dev/uinput \
      --device /dev/dri \
      --device /dev/nvidia0 \
      --device /dev/nvidiactl \
      --device /dev/nvidia-modeset \
      --device /dev/nvidia-uvm \
      --volume /run/user/1000:/run/user/1000:rw \
      --volume /tmp/.X11-unix:/tmp/.X11-unix:rw \
      --volume /run/opengl-driver:/run/opengl-driver:ro \
      --volume /home/neko/.local/share/bsdrX:/var/lib/bsdrX:rw \
      --env HOME=/var/lib/bsdrX \
      --env XDG_RUNTIME_DIR=/run/user/1000 \
      --env WAYLAND_DISPLAY=wayland-1 \
      --env DISPLAY=:0 \
      --env PULSE_SERVER=unix:/run/user/1000/pulse/native \
      --env DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
      --env LD_LIBRARY_PATH=/run/opengl-driver/lib \
      --env LIBVA_DRIVER_NAME=nvidia \
      --cap-add NET_ADMIN \
      --cap-add NET_RAW \
      bsdrx-agent:latest \
      --no-browser --wayland --web-bind 0.0.0.0 --web-allow 192.168.1.247
  '';
in
{
  systemd.paths.bsdrx-agent = {
    description = "Start bsdrX when the Wayland session is available";
    wantedBy = [ "multi-user.target" ];
    before = [ "graphical.target" ];
    pathConfig = {
      PathExists = "/run/user/1000/wayland-1";
      Unit = "bsdrx-agent.service";
    };
  };

  systemd.services.bsdrx-agent = {
    description = "bsdrX Bigscreen Remote Desktop agent (rootful Podman)";
    after = [ "network-online.target" "bsdrx-secondary-lan-address.service" ];
    wants = [ "network-online.target" ];
    requires = [ "bsdrx-secondary-lan-address.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${runBsdrx}";
      ExecStop = "-${pkgs.podman}/bin/podman stop --ignore --time 10 bsdrx-agent";
      Restart = "on-failure";
      RestartSec = 3;
      SupplementaryGroups = [ "uinput" "video" "render" ];
    };
  };
}
