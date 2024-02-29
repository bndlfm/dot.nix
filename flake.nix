{

description = "My First (System) Flake (godspeed)";

inputs = {
  nixpkgs.url = "nixpkgs/nixos-unstable";
  home-manager = {
    url = "github:n-hass/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    };
  flake-utils.url = "github:numtide/flake-utils";
  nix-flatpak.url = "github:gmodena/nix-flatpak";
  spicetify-nix.url = "github:the-argus/spicetify-nix";
  };


outputs = { nixpkgs, home-manager, flake-utils, spicetify-nix, nix-flatpak,  ... }: let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    };
in {
  firefox-GPT = pkgs.firefox-devedition.unwrapped.overrideAttrs (oldAttrs: {
    name = "firefox-GPT";
    patches = [
      ( pkgs.fetchpatch {
         url = "https://raw.githubusercontent.com/bndlfm/ffMemoryCache/main/ext-tabs.js.patch";
         sha256 = "sha256-Kp21VA4d9RRdP3wwyiu54E4w5b3qbcZBz5YlqAM1Q7I=";
         })
      ( pkgs.fetchpatch {
         url = "https://raw.githubusercontent.com/bndlfm/ffMemoryCache/main/tabs.json.patch";
         sha256 = "sha256-jXBmT/LUfwYXT+GKb1cj9g7aIFQDTN24nRceBnwoCOA=";
         })
      ];
    });

  nixosConfigurations."meow" = nixpkgs.lib.nixosSystem {
    modules = [
      ./configuration.nix
      ./hardware-configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          #extraSpecialArgs.flake-inputs = inputs;
          useUserPackages = true;
          users."neko" = {
            imports = [
              ./home.nix
              spicetify-nix.homeManagerModule
              nix-flatpak.homeManagerModules.nix-flatpak
              ];
            programs.spicetify = {
              enable = true;
              theme = spicetify-nix.packages.${system}.default.themes.catppuccin;
              colorScheme = "mocha";
              enabledExtensions = with spicetify-nix.packages.${system}.default.extensions; [
                fullAppDisplay
                shuffle
                hidePodcasts
                ];
              enabledCustomApps = with spicetify-nix.packages.${system}.default.apps; [
                marketplace
                ];
              };
            };
          };
        }
      ];
    };
  };

}

