{ config, pkgs, ... }:

{
  services.podman = {
    enable = true;
    containers.flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      autoStart = true;
      ports = [
        "8191:8191/tcp"
      ];
      environment = {
        LOG_LEVEL = "info";
      };
    };
  };
}
