{ ... }:

{
  services = {
    # Caddy vhost for Home Assistant is configured at the system level in
    # blocks/caddy-tailscale.sys.nix
    podman = {
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
  };
}
