{
  description = "My First (System) Flake (godspeed)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:n-hass/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs:
    #flake-utils.lib.eachDefaultSystem (system: let
    let
      system = "x86_64-linux";
      overlays = [
        (self: super: {
          firefox-dev-custom = super.firefox-devedition.overrideAttrs (oldAttrs: rec {
            name = "firefox-dev-custom";
            patches = oldAttrs.patches ++ [
              (super.fetchPatch "${self}/patches/ext-tabs.js.patch")
              (super.fetchPatch "${self}/patches/tabs.json.patch")
            ];
          });
        })
      ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
      hmPkgs = import home-manager {
          inherit pkgs;
      };
    in {
      nixosConfigurations = {
        meow = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            # Uncomment and adjust the path to include sops-nix if needed
            # "${self}/modules/sops.nix"
          ];
        };
      };
      homeConfigurations.neko = hmPkgs.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "neko";
          homeDirectory = "/home/neko";
          configuration = { config, lib, pkgs, ... }: {
            programs.home-manager.enable = true;
            home.packages = with pkgs; [
              firefox-dev-custom # Use the customized Firefox package
            ];
          };
        };
      };

}
