{
  description = "My First (System) Flake (godspeed)";

  inputs = {
    /* BASICS */
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";

    /* HOME MANAGER PODMAN FORK */
    home-manager = {
      url = "github:n-hass/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /* MISC PACKAGE */
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

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
    stylix.url = "github:danth/stylix";
  };


  outputs = { nixpkgs, flake-utils, nur, home-manager, flatpaks, base16, spicetify-nix, stylix, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations."meow" = lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          nur.nixosModules.nur

          /*----------------------------------------THEMING---------------------------------------*/
          stylix.nixosModules.stylix
          {
            stylix = {
              base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

              image = ./wallpapers/2016-05-02-1462223680-7138559-BD_PRESS_KIT__1.326.1.jpg;
              #{
              #   name = "Kazuha.jpg";
              #   url = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.hdwallpapers.in%2Fdownload%2Fkazuha_4k_hd_genshin_impact_3-HD.jpg";
              #   sha256 = "u1OdK21k1sFBLQqLDjLBv/SRm6oiF36QRKrPTqjyohY=";
              # };

              polarity = "dark";

              fonts = rec {
                monospace = {
                  name = "Fira Code";
                  package = pkgs.fira-code;
                };
                sansSerif = {
                  name = "Cantarell";
                  package = pkgs.cantarell-fonts;
                };
                serif = sansSerif;
              };

              cursor = {
                package = pkgs.volantes-cursors;
                name = "volantes-cursors";
                size = 32;
              };

              autoEnable = false;
              targets = {
                chromium.enable = true;
                gtk.enable = true;
              };
            };
          }

          base16.nixosModule
          {
            scheme = "${inputs.tt-schemes}/base16/nord.yaml";
          }

          /*----------------------------------------HOME-MANAGER-----------------------------------*/
          home-manager.nixosModules.home-manager
          {
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
