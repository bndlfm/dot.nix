{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://ezkea.cachix.org" # AN ANIME GAME LAUNCHER
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ezeak.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" # AN ANIME GAME LAUNCHER
    ];
  };


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ### CUSTOMIZATION
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    stylix.url = "github:danth/stylix";
    ### PROGRAMS
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ### VMs
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ### SECRETS
    sops-nix.url = "github:Mic92/sops-nix";

    ### WINDOW MANAGER
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    niri.url = "github:sodiboo/niri-flake";
  };


  outputs = {
    nixpkgs,
    home-manager,

    nix-flatpak,
    aagl,

    microvm,

    sops-nix,

    spicetify-nix,
    stylix,

    hyprland,
    niri,
    ...
  }@inputs:


  let
    system = "x86_64-linux";
  in {


    ### USER CONFIGURATIONS ###
      packages.${system} = {
        homeConfigurations."neko" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            nix-flatpak.homeManagerModules.nix-flatpak

            inputs.sops-nix.homeManagerModules.sops

            spicetify-nix.homeManagerModule ( import ./theme/spicetify.nix {inherit spicetify-nix;})

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


      nixosConfigurations = {
        "meow" = nixpkgs.lib.nixosSystem {

          modules = [
            nix-flatpak.nixosModules.nix-flatpak
            aagl.nixosModules.default ( import ./programs/nx/an-anime-game-launcher.nix {inherit aagl;})

            microvm.nixosModules.host {
              microvm.autostart = [];
            }

            sops-nix.nixosModules.sops

            stylix.nixosModules.stylix ( import ./theme/nxStylix.nix )

            hyprland.nixosModules.default
            niri.nixosModules.niri

            ./systems/meow/configuration.nix
            ./systems/meow/hardware-configuration.nix
          ];
        };

        "nyaa" = nixpkgs.lib.nixosSystem {
          modules = [
            nix-flatpak.nixosModules.nix-flatpak
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
