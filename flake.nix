{
  inputs = {
    ### NIX
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    ### CUSTOMIZATION
      stylix = {
        url = "github:Mikilio/stylix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      tt-schemes = {
        url = "github:tinted-theming/schemes";
        flake = false;
      };
      base16.url = "github:SenchoPens/base16.nix";
    ### MEDIA
      nixarr = {
        url = "github:rasmus-kirk/nixarr";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      spicetify-nix = {
        url = "github:Gerg-L/spicetify-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    ### PROGRAMS
      aagl = {
        url = "github:ezKEa/aagl-gtk-on-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      deejavu = {
        url = "github:bndlfm/deejavu";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      openmw-vr = {
        url = "github:bndlfm/openmw-vr.nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    ### SECRETS
      sops-nix.url = "github:Mic92/sops-nix";
    ### WINDOW MANAGER
      #hyprland = {
      #    url = "git+https://github.com/hyprwm/Hyprland?submodules=1&tag=v0.46.2";
      #    inputs.nixpkgs.follows = "nixpkgs";
      #  };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,

    aagl,
    deejavu,

    nixarr,
    spicetify-nix,

    sops-nix,

    stylix,

    ...
  }@inputs: let
      inherit (self) outputs;
      #Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
      overlays = import ./overlays {inherit inputs;};
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

     /***********************
      * HOME CONFIGURATIONS *
      ***********************/
      homeConfigurations = {
        "neko@meow" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
            };
          modules = [
            ## THEMING
              stylix.homeManagerModules.stylix (import ./theme/hmStylix.nix)
            ## IMPORTS
              ./nekoHome.nix
            ];
          };
        "neko@nyaa" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            inputs.sops-nix.homeManagerModules.sops
            ./users/server/home.nix
          ];
        };
      };


     /************************
      * NIXOS CONFIGURATIONS *
      ************************/
      nixosConfigurations = {
        "meow" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ## MEDIA
              nixarr.nixosModules.default ( import ./modules/nx/nixarr.nix )
            ## SECRETS
              sops-nix.nixosModules.sops
            ## THEMING
              stylix.nixosModules.stylix ( import ./theme/nxStylix.nix )
            ## WINDOW MANAGERS
              #hyprland.nixosModules.default
            ## IMPORTS
              ./meowSystem.nix
              ./meowHardware.nix
          ];
        };
        "nyaa" = nixpkgs.lib.nixosSystem {
          modules = [
            ./systems/nyaa/configuration.nix
            ./systems/nyaa/hardware-configuration.nix
          ];
        };
      };
  };
}
