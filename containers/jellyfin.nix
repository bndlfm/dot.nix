{ ... }:

{
  virtualisation = {
    oci-containers = {
      backend = "podman";
      containers."jellyfin" = {
        image = "docker.io/jellyfin/jellyfin:latest";
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        autoStart = true;
        ports = [
          "8096:8096"
          "8920:8920"
          "1900:1900"
          "7359:7359"
        ];
        environment = {
          NVIDIA_VISIBLE_DEVICES = "all";
          NVIDIA_DRIVER_CAPABILITIES = "all";
          JELLYFIN_PublishedServerUrl = "192.168.1.5";
        };
        volumes = [
          "/media/.cache:/cache"
          "/media/.jellyfin:/config"
          "/media:/media"
        ];
      };
    };
  };
}
