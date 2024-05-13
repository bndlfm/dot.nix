{ home-manager, ... }:
let
  homeDir = "/home/server/dotnix/containers/grimoire";
in {
  services.podman.networks = {
    grimoire_net = {
      driver = "bridge";
      subnet = "192.168.2.0/24";
    };
  };

  services.podman.containers.pocketbase = {
    image = "docker.io/pocketbase:0.19.2";
    description = "Grimoire bookmarks manager DB";
    networks = [ "grimoire_net" ];
    networkAlias = "pocketbase";
    ports = [
      "8090:80"
    ];
    restart = "unless-stopped";
    volumes = [
      "${homeDir}/pb_data:/pb_data"
      "${homeDir}/pb_migrations:pb_migrations"
      "/etc/timezone:/etc/timezone:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
    autoupdate = "registry";
  };

  services.podman.containers.grimoire = {
    image = "docker.io/goniszewski/grimoire:latest";
    description = "Grimoire bookmarks manager";
    environmentFile = "${homeDir}/grimoire/.env";
    networks = [ "grimoire_net" ];
    networkAlias = "grimoire";
    ports = [
      "5173:5173"
    ];
    volumes = [
      "/etc/timezone:/etc/timezone:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
    autoupdate = "registry";
  };
}
