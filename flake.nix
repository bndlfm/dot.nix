{
  inputs = {
  /********************
  * PERMANENT INPUTS *
  ********************/
  ## NIX
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";
    lix-module =
      {
        url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-1.tar.gz";
        inputs.nixpkgs.follows = "nixpkgs";
      };

  ## CUSTOMIZATION
    stylix.url = "github:Mikilio/stylix";
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    base16.url = "github:SenchoPens/base16.nix";

  ## MEDIA
    nixarr.url = "github:rasmus-kirk/nixarr";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

  ## PROGRAMS
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    deejavu.url = "github:bndlfm/deejavu";
    isd.url = "github:isd-project/isd";
    openmw-vr.url = "github:bndlfm/openmw-vr.nix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

  ## SECRETS
    sops-nix.url = "github:Mic92/sops-nix";

  ## WINDOW MANAGER
    niri.url = "github:sodiboo/niri-flake";

  /***************
  * TEMP INPUTS *
  ***************/
  ## NOTE: Check if fixed upstream!
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
  };


  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      lix-module,

      deejavu,
      nixarr,

      niri,

      spicetify-nix,
      sops-nix,
      stylix,
      ...
    }@inputs:

    let
      inherit (self) outputs;

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      # Fctunction that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Convert overlays to a list
      overlays = with (import ./overlays {inherit inputs;}); [
        additions
        modifications
        nixpkgs-stable
      ];
    in {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;


     /***********************
      * HOME CONFIGURATIONS *
      ***********************/
      homeConfigurations =
        {
          "neko@meow" = home-manager.lib.homeManagerConfiguration
            {
              pkgs = nixpkgs.legacyPackages.x86_64-linux.appendOverlays overlays;
              extraSpecialArgs =
                {
                  inherit inputs outputs;
                };
              modules =
                [
                  ## NIRI
                    niri.homeModules.niri
                  ## THEMING
                    stylix.homeManagerModules.stylix (import ./theme/hmStylix.nix)
                  ## IMPORTS
                    ./neko.home.nix
                ];
            };
          "neko@nyaa" = home-manager.lib.homeManagerConfiguration
            {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              modules =
                [
                  ## SECRETS
                    inputs.sops-nix.homeManagerModules.sops
                  ## IMPORTS
                    ./server.home.nix
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
            ({ nixpkgs.overlays = overlays; })
            #lix-module.nixosModules.default
            ## MEDIA
              nixarr.nixosModules.default (import ./modules/nixarr.sys.nix)
            ## SECRETS
              sops-nix.nixosModules.sops
            ## THEMING
              stylix.nixosModules.stylix (import ./theme/nxStylix.nix)
            ## WINDOW MANAGERS
              niri.nixosModules.niri
              {
                programs.niri = {
                  enable = true;
                  package = inputs.niri.packages.x86_64-linux.niri-unstable;
                };
                niri-flake.cache.enable = true;
              }
            ## IMPORTS
              ./meow.sys.nix
              ./meow.hardware.nix
          ];
        };
        "nyaa" = nixpkgs.lib.nixosSystem {
          modules = [
            ## IMPORTS
              ./server.sys.nix
              ./server.hardware.nix
          ];
        };
      };
  };
}
