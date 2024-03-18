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
    nur.url = "github:nix-community/NUR";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    agenix.url = "github:ryantm/agenix";

    ### THEMING:
    base16.url = "github:SenchoPens/base16.nix";
    base16-zathura = {
      url = "github:haozeke/base16-zathura";
      flake = false;
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { home-manager, nixpkgs, agenix, nur, flatpaks, spicetify-nix, base16, stylix, ... }:
    let
      username = "neko";
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      spicePkgs = spicetify-nix.packages.${system}.default;
    in
    {
      packages.${system} = {
        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            flatpaks.homeManagerModules.default
            spicetify-nix.homeManagerModule
            ./home.nix
            ./packages/packages.nix
            ./modules/hmProgramModules.nix
            agenix.homeManagerModules.default
            {
              programs = {
                spicetify = {
                  enable = true;
                  theme = spicePkgs.themes.Matte;
                  colorScheme = "Matte";
                  enabledExtensions = with spicePkgs.extensions; [
                    fullAppDisplay
                    hidePodcasts
                  ];
                  enabledCustomApps = with spicePkgs.apps; [
                    marketplace
                  ];
                };
              };
            }
            base16.homeManagerModule
            {
              scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
            }
            stylix.homeManagerModules.stylix
            ( import ./theme/hmStylix.nix { inherit nixpkgs; })
          ];
        };

        nixosConfigurations."meow" = nixpkgs.lib.nixosSystem
          {
            modules = [
              ./configuration.nix
              ./hardware-configuration.nix
              agenix.nixosModules.default
              nur.nixosModules.nur
              base16.nixosModule
              {
                scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
              }
              stylix.nixosModules.stylix
              ( import ./theme/nxStylix.nix { inherit nixpkgs; })
            ];
          };
      };
    };
}

