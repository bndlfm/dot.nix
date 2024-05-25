# See how this flake is used in ./usage.sh
{
  inputs.extra-container.url = "github:erikarvstedt/extra-container";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { extra-container, ... }@inputs:
    extra-container.lib.eachSupportedSystem (system: {
      packages.default = extra-container.lib.buildContainers {
        # The system of the container host
        inherit system;

        # If unset, the nixpkgs input of extra-container flake is used
        nixpkgs = inputs.nixpkgs;

        # Set this to disable `nix run` support
        # addRunner = false;

        config = {
          containers.demo = {
            extra.addressPrefix = "192.168.1";

            # `specialArgs` is available in nixpkgs > 22.11
            # This is useful for importing flakes from modules (see nixpkgs/lib/modules.nix).
            # specialArgs = { inherit inputs; };

            config = { pkgs, ... }: {
              services = {
                jellyfin = {
                  enable = true;
                  configDir = "/media/.jellyfin/config/";
                  dataDir = "/media/.jellyfin/data/";
                  logDir = "/media/.jellyfin/log/";
                  openFirewall = true;
                };
                jellyseerr = {
                  enabled = true;
                  openFirewall = true;
                };
                radarr = {
                  enable = true;
                  openFirewall = true;
                  dataDir = "/media/.radarr/";
                };
              };
            };
          };
        };
      };
    });
}
