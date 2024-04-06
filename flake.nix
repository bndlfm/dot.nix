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
      url = "github:bndlfm/home-manager-nhass";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpak.url = "github:GermanBread/declarative-flatpak/stable";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### SECRETS
    sops-nix.url = "github:Mic92/sops-nix";

    ### THEMING:
    stylix.url = "github:danth/stylix";
  };

  outputs = { home-manager, microvm, nixpkgs, flatpak, sops-nix, spicetify-nix, stylix, ... }@inputs:
    let
      username = "neko";
      system = "x86_64-linux";
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

            inputs.sops-nix.homeManagerModules.sops

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

              #microvm.nixosModules.microvm
              #{
              #  networking.hostName = "microvm";
              #  users.users.root.password = "";
              #  microvm = {
              #    volumes = [ {
              #      mountPoint = "/var";
              #      image = "var.img";
              #      size = 256;
              #    } ];
              #    shares = [ {
              #      # use "virtiofs" for MicroVMs that are started by systemd
              #      proto = "9p";
              #      tag = "ro-store";
              #      # a host's /nix/store will be picked up so that no
              #      # squashfs/erofs will be built for it.
              #      source = "/nix/store";
              #      mountPoint = "/nix/.ro-store";
              #    } ];

              #    hypervisor = "qemu";
              #    socket = "control.socket";
              #  };
              #}

              sops-nix.nixosModules.sops

              stylix.nixosModules.stylix
              ( import ./modules/theme/nxStylix.nix )
            ];
          };
      };
    };
}

