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
      #url = "github:bndlfm/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpak.url = "github:GermanBread/declarative-flatpak/stable";

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### USERCSS
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    ### SECRETS
    sops-nix.url = "github:Mic92/sops-nix";

    ### THEMING:
    stylix.url = "github:danth/stylix";
  };

  outputs = { home-manager, nixpkgs, flatpak, microvm, sops-nix, spicetify-nix, stylix, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      packages.${system} = {
        homeConfigurations."neko" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./systems/meow/home.nix
            ./programs/hmPrograms.nix

            flatpak.homeManagerModules.default
            ./modules/hmServices.nix

            inputs.sops-nix.homeManagerModules.sops

            stylix.homeManagerModules.stylix
            ( import ./theme/hmStylix.nix )

            spicetify-nix.homeManagerModule
            ( import ./theme/spicetify.nix {inherit spicetify-nix;})
          ];
        };

        /*
         *
         *   NOTE: SYSTEM CONFIGURATIONS
         *
         */

      ### DESKTOP
        nixosConfigurations."meow" = nixpkgs.lib.nixosSystem
          {
            modules = [
              ./systems/meow/configuration.nix
              ./systems/meow/hardware-configuration.nix

              microvm.nixosModules.host
              {
                microvm.autostart = [ ];
              }

              sops-nix.nixosModules.sops

              stylix.nixosModules.stylix
              ( import ./theme/nxStylix.nix )
            ];
          };

      ### SERVER
        nixosConfigurations."nyaa" = nixpkgs.lib.nixosSystem
          {
            modules = [
              ./systems/nyaa/configuration.nix
              ./systems/nyaa/hardware-configuration.nix
            ];
          };

      };
    };
}

