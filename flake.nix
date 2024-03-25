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
      url = "github:n-hass/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpak.url = "github:GermanBread/declarative-flatpak/stable";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    ### SECRETS
    agenix.url = "github:ryantm/agenix";

    ### THEMING:
    stylix.url = "github:danth/stylix";
  };

  outputs = { home-manager, nixpkgs, agenix, flatpak, spicetify-nix, stylix, ... }:
    let
      username = "neko";
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home.nix
            ./modules/hmPackages.nix
            ./modules/hmPrograms.nix
            flatpak.homeManagerModules.default
            ./modules/hmServices.nix

            agenix.homeManagerModules.default

            stylix.homeManagerModules.stylix
            ( import ./modules/theme/hmStylix.nix )

            spicetify-nix.homeManagerModule
            ( import ./modules/theme/spicetify.nix {inherit spicetify-nix;})
          ];
        };

        nixosConfigurations."meow" = nixpkgs.lib.nixosSystem
          {
            modules = [
              ./configuration.nix
              ./hardware-configuration.nix

              agenix.nixosModules.default

              stylix.nixosModules.stylix
              ( import ./modules/theme/nxStylix.nix )
            ];
          };
      };
    };
}

