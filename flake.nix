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

    extra-container.url = "github:erikarvstedt/extra-container";

    flatpak.url = "github:GermanBread/declarative-flatpak/stable";

    funkwhale.url = "github:/mmai/funkwhale-flake";

    #grimoire-flake.url = "git+file:///home/server/dotnix/containers/grimoire/flake.nix";

    nixos-cosmic = {
      url = "github:/lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs = { home-manager, nixpkgs, flatpak, microvm, sops-nix, spicetify-nix, stylix, nixos-cosmic, ... }@inputs:

    let
      system = "x86_64-linux";
    in {

    ###  NOTE: USER CONFIGURATIONS
      packages.${system} = {
        homeConfigurations."neko" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./users/neko/home.nix
            ./programs/hmPrograms.nix

            flatpak.homeManagerModules.default
            ./services/hmServices.nix

            inputs.sops-nix.homeManagerModules.sops

            stylix.homeManagerModules.stylix
            ( import ./theme/hmStylix.nix )

            spicetify-nix.homeManagerModule
            ( import ./theme/spicetify.nix {inherit spicetify-nix;})
          ];
        };

        homeConfigurations."server" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./users/neko/home.nix
            inputs.sops-nix.homeManagerModules.sops
          ];
        };

      ###  NOTE: SYSTEM CONFIGURATIONS

      nixosConfigurations = {
      ### DESKTOP
        "meow" = nixpkgs.lib.nixosSystem {
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
        "nyaa" = nixpkgs.lib.nixosSystem {
          modules = [
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/"];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            nixos-cosmic.nixosModules.default
            ./systems/nyaa/configuration.nix
            ./systems/nyaa/hardware-configuration.nix
          ];
        };
      };
    };
  };
}



          ###
          ###  NOTE: CONTAINERS
          ###
          /*
          funkwhale = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            modules = [
              funkwhale.nixosModules.default
              ( { pkgs, ... }:
              let
                hostname = "funkwhale";
                secretFile = pkgs.writeText "djangoSecret" "test123";
              in {
                boot.isContainer = true;
                #system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
                system.stateVersion = "23.05";

                networking = {
                  useDCHP = false;
                  firewall.allowedTCPPorts = [ 80 ];
                  hostName = "${hostname}";
                };
                nixpkgs.overlays = [ funkwhale.overlays.default ];

                services.funkwhale = {
                  enable = true;
                  hostname = "${hostname}";
                  # typesenseKey = "my typesense key";
                  defaultFromEmail = "noreply@funkwhale.rhumbs.fr";
                  protocol = "http"; # no ssl for virtualbox
                  forceSSL = false; # uncomment when LetsEncrypt needs to access "http:" in order to check domain
                  api = {
                      djangoSecretKeyFile = "${secretFile}";
                  };
                };
                # Overrides default 30M
                services.nginx.clientMaxBodySize = "100m";
                #environment.systemPackages = with pkgs; [ neovim ];
              })
            ];
          };
          */
