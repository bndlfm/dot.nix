{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:n-hass/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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

  outputs = { flake-utils, home-manager, nixpkgs, nur, flatpaks, spicetify-nix, base16, stylix, ... }@inputs:
    let
      username = "neko";
      system = "x86_64-linux";
      pkgs = nixpkgs;
      spicePkgs = spicetify-nix.packages.${system}.default;
    in
    {
      packages.${system} = {
        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            spicetify-nix.homeManagerModule
            flatpaks.homeManagerModules.default
            ./home.nix
            {
              programs = {
                spicetify = {
                  enable = true;
                  theme = spicePkgs.themes.catppuccin;
                  colorScheme = "catppuccin";
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
              ./modules/stylix.nix
            ];
          };
      };
    };
}

