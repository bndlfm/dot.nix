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

    ### THEMING:
    base16.url = "github:SenchoPens/base16.nix";
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    base16-zathura = {
      url = "github:haozeke/base16-zathura";
      flake = false;
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { home-manager, nixpkgs, nur, flatpaks, spicetify-nix, base16, tt-schemes, stylix, ... }@inputs:
    let
      username = "neko";
      system = "x86_64-linux";
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
            ./modules/hmProgramModules.nix
            ./packages/packages.nix
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
              scheme = "${inputs.tt-schemes}/base16/nord.yaml";
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
              nur.nixosModules.nur
              base16.nixosModule
              {
                scheme = "${inputs.tt-schemes}/base16/nord.yaml";
              }
              stylix.nixosModules.stylix
              ( import ./theme/nxStylix.nix { inherit nixpkgs; })
            ];
          };
      };
    };
}

