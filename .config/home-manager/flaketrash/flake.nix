{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nix-flatpak, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
            inherit system;
          };
      in {
        homeConfigurations = {
          nyeko = home-manager.lib.homeManagerConfiguration {
            system = "x86_64-linux";
            homeDirectory = "/home/nyeko";
            username = "nyeko";
            configuration = import ./home.nix;
            };
          };
        });
}
#         modules = [
#            nix-flatpak.homeManagerModules.nix-flatpak
#            ./home.nix
#            ];
#          nixpkgs = {
#            config = { allowUnfree = true; };
#            };
#        };
#          };
#        };
#      };

#activationPackage = home-manager.lib.homeManagerConfiguration {
#  specialArgs.inputs = inputs;
#  system = "x86_64-linux";
#  };
# vim: ft=nix
