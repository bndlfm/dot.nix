{
  inputs = {
    ### NIX
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixos-cli.url = "github:water-sucks/nixos";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    ### CUSTOMIZATION
      spicetify-nix = {
        url = "github:Gerg-L/spicetify-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      stylix.url = "github:danth/stylix";
      tt-schemes = {
        url = "github:tinted-theming/schemes";
        flake = false;
      };
      base16.url = "github:SenchoPens/base16.nix";
    ### PROGRAMS
      aagl = {
        url = "github:ezKEa/aagl-gtk-on-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      flatpak.url = "github:gmodena/nix-flatpak";
    ### SECRETS
      sops-nix.url = "github:Mic92/sops-nix";
    ### WINDOW MANAGER
      hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      hyprscroller.url = "github:dawsers/hyprscroller";
      niri.url = "github:sodiboo/niri-flake";
  };

  outputs = {
    nixpkgs,
    nixos-cli,
    home-manager,

    flatpak,
    spicetify-nix,

    sops-nix,

    stylix,

    hyprland,
    niri,
    ...
  }@inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {


    packages.x86_64-linux = {
      homeConfigurations = {
        "neko" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit inputs;
            };
          modules = [
              flatpak.homeManagerModules.nix-flatpak
              inputs.spicetify-nix.homeManagerModules.default ( import ./theme/spicetify.nix {inherit spicetify-nix;})
            ## SECRETS
              inputs.sops-nix.homeManagerModules.sops
            ## THEMING
              stylix.homeManagerModules.stylix ( import ./theme/hmStylix.nix )
            ## WINDOW MANAGERS
              niri.homeModules.niri ( import ./windowManagers/hm/niri.nix {inherit niri;})
            ## IMPORTS
              ./users/neko/home.nix
            ];
          };
        "server" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            inputs.sops-nix.homeManagerModules.sops
            ./users/server/home.nix
          ];
        };
      };

      nixosConfigurations = {
        "meow" = nixpkgs.lib.nixosSystem {
          modules = [
            ## PROGRAMS
              nixos-cli.nixosModules.nixos-cli
              flatpak.nixosModules.nix-flatpak
              #aagl.nixosModules.default ( import ./programs/nx/an-anime-game-launcher.nix {inherit aagl;})
            ## SECRETS
              sops-nix.nixosModules.sops
            ## THEMING
              stylix.nixosModules.stylix ( import ./theme/nxStylix.nix )
            ## WINDOW MANAGERS
              hyprland.nixosModules.default
              niri.nixosModules.niri ( import ./windowManagers/nx/niri.nix {inherit pkgs niri;})
            ## IMPORTS
              ./systems/meow/configuration.nix
              ./systems/meow/hardware-configuration.nix
          ];
        };
        "nyaa" = nixpkgs.lib.nixosSystem {
          modules = [
            flatpak.nixosModules.nix-flatpak
            ./systems/nyaa/configuration.nix
            ./systems/nyaa/hardware-configuration.nix
          ];
        };
      };
    };
  };
}
