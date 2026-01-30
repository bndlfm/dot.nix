{ config, pkgs, ... }:

{
  services.podman = {
    enable = true;
    containers.homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      autoStart = true;
      network = "host";
      volumes = [
        "/mnt/data/homeassistant:/config"
      ];
      environment = {
        TZ = "America/Chicago";
      };
    };
  };
}
