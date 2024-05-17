{ ... }:

{
  # Home Assistant
  virtualisation.oci-containers.containers."homeassistant" = {
    autoStart = true;
    image = "ghcr.io/home-assistant/home-assistant:stable";
    volumes = [
      "/home/server/HomeAssistant:/config"
      "/etc/localtime:/etc/localtime:ro"
    ];
    extraOptions = [
      "--device=/dev/ttyUSB0"
      "--network=host"
      "--privileged"
    ];
  };
}
