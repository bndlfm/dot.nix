{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpak.url = "github:GermanBread/declarative-flatpak/stable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    niri.url = "github:sodiboo/niri-flake";
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:danth/stylix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    flatpak,
    hyprland,
    microvm,
    niri,
    sops-nix,
    spicetify-nix,
    stylix,
    ...
  }@inputs: let
    system = "x86_64-linux";
  in {

    ### USER CONFIGURATIONS ###
      packages.${system} = {
        homeConfigurations."neko" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            flatpak.homeManagerModules.default

            inputs.sops-nix.homeManagerModules.sops

            spicetify-nix.homeManagerModule ( import ./theme/spicetify.nix {inherit spicetify-nix;} )
            stylix.homeManagerModules.stylix ( import ./theme/hmStylix.nix )

            ./users/neko/home.nix
          ];
        };
        homeConfigurations."server" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            inputs.sops-nix.homeManagerModules.sops
            ./users/server/home.nix
          ];
        };


    ### SYSTEM CONFIGURATIONS ###
      nixosConfigurations = {
      ### DESKTOP
        "meow" = nixpkgs.lib.nixosSystem {
          modules = [
            ### WINDOW MANAGERS
            hyprland.nixosModules.default {
              programs.hyprland = {
                enable = true;
                xwayland.enable = true;
              };
            }
            niri.nixosModules.niri

            microvm.nixosModules.host {
              microvm.autostart = [];
            }

            sops-nix.nixosModules.sops

            stylix.nixosModules.stylix ( import ./theme/nxStylix.nix )
            ./systems/meow/configuration.nix
            ./systems/meow/hardware-configuration.nix
          ];
        };
        "nyaa" = nixpkgs.lib.nixosSystem {         ### SERVER
          modules = [
            ### WINDOW MANAGER
            hyprland.nixosModules.default {
              programs.hyprland = {
                enable = true;
                xwayland.enable = true;
              };
            }
            niri.nixosModules.niri

            flatpak.nixosModules.default

            ./systems/nyaa/configuration.nix
            ./systems/nyaa/hardware-configuration.nix
          ];
        };
      };
    };
  };
}
