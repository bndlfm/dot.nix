{ ... }:{
  virtualisation = {
    oci-containers = {
      backend = "podman";
      containers."retroarch-web" = {
        image = "docker.io/antoine13/retroarch-web-games:latest";
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        autoStart = true;
        ports = [
          "4207:8080"
        ];
        environment = {
        };
        volumes = [
          "/home/neko/ROMs:/saved_roms"
        ];
      };
    };
  };
}

