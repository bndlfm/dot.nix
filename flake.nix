{
  description = "My First (System) Flake (godspeed)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:n-hass/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      };
    flake-utils.url = "github:numtide/flake-utils";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";

    /* RICE */
    base16.url = "github:SenchoPens/base16.nix";
    tt-schemes = {
        url = "github:tinted-theming/schemes";
        flake = false;
      };
    base16-zathura = {
      url = "github:haozeke/base16-zathura";
      flake = false;
      };
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    stylix.url = "github:danth/stylix";
    };


  outputs = { nixpkgs, home-manager, flatpaks, base16, spicetify-nix, stylix,  ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations."meow" = lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          stylix.nixosModules.stylix
          base16.nixosModule {
              scheme = "${inputs.tt-schemes}/base16/nord.yaml";
            }
          home-manager.nixosModules.home-manager {
            home-manager = {
              useUserPackages = true;
              users."neko" = {
                imports = [
                  spicetify-nix.homeManagerModule
                  flatpaks.homeManagerModules.default
                  ./home.nix
                  ];
                programs = {
                  spicetify = {
                    enable = true;
                    theme = spicetify-nix.packages.${system}.default.themes.catppuccin;
                    colorScheme = "catppuccin";
                    enabledExtensions = with spicetify-nix.packages.${system}.default.extensions; [
                      fullAppDisplay
                      hidePodcasts
                      ];
                    enabledCustomApps = with spicetify-nix.packages.${system}.default.apps; [
                      marketplace
                      ];
                    };
                  };
                };
              };
            }
          ];
        };
      };
}

    #firefox-GPT = pkgs.firefox-devedition.unwrapped.overrideAttrs (oldAttrs: {
    #  name = "firefox-GPT";
    #  patches = [
    #    ( pkgs.fetchpatch {
    #       url = "https://raw.githubusercontent.com/bndlfm/ffMemoryCache/main/ext-tabs.js.patch";
    #       sha256 = "sha256-Kp21VA4d9RRdP3wwyiu54E4w5b3qbcZBz5YlqAM1Q7I=";
    #       })
    #    ( pkgs.fetchpatch {
    #       url = "https://raw.githubusercontent.com/bndlfm/ffMemoryCache/main/tabs.json.patch";
    #       sha256 = "sha256-jXBmT/LUfwYXT+GKb1cj9g7aIFQDTN24nRceBnwoCOA=";
    #       })
    #    ];
    #  });
