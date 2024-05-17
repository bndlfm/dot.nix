{
  description = "Grimoire flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    grimoire.url = "github:goniszewski/grimoire";
  };

  outputs = { self, nixpkgs, flake-utils, grimoire }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;

        grimoireImage = pkgs.dockerTools.buildImage {
          name = "goniszewski/grimoire";
          tag = "latest";
          copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = [ grimoire ];
            pathsToLink = [ "/app" ];
          };
          config = {
            Cmd = [ "npm" "start" ];
            WorkingDir = "/app";
          };
        };
      in {
        nixosModules.grimoire = { config, ... }: {
          # Runtime
          virtualisation.podman = {
            enable = true;
            autoPrune.enable = true;
            dockerCompat = true;
            defaultNetwork.settings = {
              # Required for container networking to be able to use names.
              dns_enabled = true;
            };
          };
          virtualisation.oci-containers.backend = "podman";

          # Containers
          virtualisation.oci-containers.containers."grimoire" = {
            image = grimoireImage;
            environment = {
              PORT = "5173";
              PUBLIC_HTTPS_ONLY = "";
              PUBLIC_ORIGIN = "http://localhost:5173";
              PUBLIC_POCKETBASE_URL = "http://100.90.24.2:8090";
              PUBLIC_SIGNUP_DISABLED = "false";
              ROOT_ADMIN_EMAIL = "admin@localhost";
              ROOT_ADMIN_PASSWORD = "cBYfB0HbsZKEF9KS";
            };
            volumes = [
              "pb_migrations:/app/pb_migrations:rw"
            ];
            ports = [
              "5173:5173/tcp"
            ];
            log-driver = "journald";
            extraOptions = [
              "--network-alias=grimoire"
              "--network=grimoire_default"
            ];
          };
          systemd.services."podman-grimoire" = {
            serviceConfig = {
              Restart = lib.mkOverride 500 "always";
            };
            after = [
              "podman-network-grimoire_default.service"
              "podman-volume-grimoire_pb_migrations.service"
            ];
            requires = [
              "podman-network-grimoire_default.service"
              "podman-volume-grimoire_pb_migrations.service"
            ];
            partOf = [
              "podman-compose-grimoire-root.target"
            ];
            wantedBy = [
              "podman-compose-grimoire-root.target"
            ];
          };
          virtualisation.oci-containers.containers."grimoire-pocketbase" = {
            image = "spectado/pocketbase:0.22.10";
            environment = {
              PORT = "5173";
              PUBLIC_HTTPS_ONLY = "";
              PUBLIC_ORIGIN = "http://localhost:5173";
              PUBLIC_POCKETBASE_URL = "http://100.90.24.2:8090";
              PUBLIC_SIGNUP_DISABLED = "false";
              ROOT_ADMIN_EMAIL = "admin@localhost";
              ROOT_ADMIN_PASSWORD = "cBYfB0HbsZKEF9KS";
            };
            volumes = [
              "pb_data:/pb_data:rw"
              "pb_migrations:/pb_migrations:rw"
            ];
            ports = [
              "8090:80/tcp"
            ];
            dependsOn = [
              "grimoire"
            ];
            log-driver = "journald";
            extraOptions = [
              "--network-alias=pocketbase"
              "--network=grimoire_default"
            ];
          };
          systemd.services."podman-grimoire-pocketbase" = {
            serviceConfig = {
              Restart = lib.mkOverride 500 "always";
            };
            after = [
              "podman-network-grimoire_default.service"
              "podman-volume-grimoire_pb_data.service"
              "podman-volume-grimoire_pb_migrations.service"
            ];
            requires = [
              "podman-network-grimoire_default.service"
              "podman-volume-grimoire_pb_data.service"
              "podman-volume-grimoire_pb_migrations.service"
            ];
            partOf = [
              "podman-compose-grimoire-root.target"
            ];
            wantedBy = [
              "podman-compose-grimoire-root.target"
            ];
          };

          # Networks
          systemd.services."podman-network-grimoire_default" = {
            path = [ pkgs.podman ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "${pkgs.podman}/bin/podman network rm -f grimoire_default";
            };
            script = ''
              podman network inspect grimoire_default || podman network create grimoire_default
            '';
            partOf = [ "podman-compose-grimoire-root.target" ];
            wantedBy = [ "podman-compose-grimoire-root.target" ];
          };

          # Volumes
          systemd.services."podman-volume-grimoire_pb_data" = {
            path = [ pkgs.podman ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect grimoire_pb_data || podman volume create grimoire_pb_data
            '';
            partOf = [ "podman-compose-grimoire-root.target" ];
            wantedBy = [ "podman-compose-grimoire-root.target" ];
          };
          systemd.services."podman-volume-grimoire_pb_migrations" = {
            path = [ pkgs.podman ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect grimoire_pb_migrations || podman volume create grimoire_pb_migrations
            '';
            partOf = [ "podman-compose-grimoire-root.target" ];
            wantedBy = [ "podman-compose-grimoire-root.target" ];
          };

          # Root service
          # When started, this will automatically create all resources and start
          # the containers. When stopped, this will teardown all resources.
          systemd.targets."podman-compose-grimoire-root" = {
            unitConfig = {
              Description = "Root target generated by compose2nix.";
            };
            wantedBy = [ "multi-user.target" ];
          };
        };
      }
    );
}
