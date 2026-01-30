{
  inputs =
    {
      /*******************
      * PERMANENT INPUTS *
      *******************/
      ## NIX
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
          url = "github:nix-community/home-manager";
        };
        nur.url = "github:nix-community/NUR";
        nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

      ## OVERLAY NIXPKGS
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
        nixpkgs-bndlfm.url = "github:bndlfm/nixpkgs";

      ## CUSTOMIZATION
        base16.url = "github:SenchoPens/base16.nix";
        stylix.url = "github:Mikilio/stylix";
        tt-schemes = {
          url = "github:tinted-theming/schemes";
          flake = false;
        };

      ## MEDIA
        nixarr.url = "github:rasmus-kirk/nixarr";
        spicetify-nix.url = "github:Gerg-L/spicetify-nix?rev=f0595e3b59260457042450749eaec00a5a47db35";

      ## PROGRAMS
        aagl.url = "github:ezKEa/aagl-gtk-on-nix";
        moltbot = {
          url = "path:/home/neko/Projects/nix-moltbot";
          inputs.nixpkgs.follows = "nixpkgs";
        };
        #deejavu.url = "github:bndlfm/deejavu";
        #jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS";
        llama-cpp_ik = {
          url = "github:ikawrakow/ik_llama.cpp";
          inputs.nixpkgs.follows = "nixpkgs";
        };
        lsfg-vk = {
          url = "github:pabloaul/lsfg-vk-flake/main";
          inputs.nixpkgs.follows = "nixpkgs";
        };
        openmw-vr.url = "github:bndlfm/openmw-vr.nix";
        zen-browser = {
          url = "github:0xc000022070/zen-browser-flake";
          inputs.nixpkgs.follows = "nixpkgs";
        };

      ## SECRETS
        sops-nix.url = "github:Mic92/sops-nix";

      ## SERVICES
        caddy-nix.url = "github:vincentbernat/caddy-nix";

      ## WINDOW MANAGER
        niri.url = "github:sodiboo/niri-flake";
        hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

      /*********************
      * ALTERNATIVE INPUTS *
      *********************/
      ## NOTE: Check if fixed upstream!
    };



  nixConfig =
    {
      extra-subsituters =
        [
          "https://cache.nixos.org"
        ];
      extra-trusted-public-keys =
        [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
    };



  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      nix-flatpak,

      aagl,
      moltbot,
      lsfg-vk,
      nixarr,

      hyprland,
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
      # Function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Convert overlays to a list
      overlays = with (import ./overlays {inherit inputs;}); [
        additions
        modifications
        nixpkgs-stable
        nixpkgs-bndlfm
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
              extraSpecialArgs = { inherit inputs outputs; };
              modules =
                [
                  ## CLAWDBOT
                    moltbot.homeManagerModules.moltbot (import ./programs/moltbot.home.nix)
                  ## FLATPAK
                    nix-flatpak.homeManagerModules.nix-flatpak (import ./services/flatpak.home.nix)
                  ## NIRI
                    niri.homeModules.niri
                  ## THEMING
                    stylix.homeModules.stylix (import ./theme/hmStylix.nix)
                  ## ZEN BROWSER
                    inputs.zen-browser.homeModules.twilight (import ./programs/zen-browser.home.nix)
                  ## IMPORTS
                    ./home/neko/default.nix
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
                    ./home/server/default.nix
                ];
            };
        };


     /************************
      * NIXOS CONFIGURATIONS *
      ************************/
      nixosConfigurations =
        {
          "meow" = nixpkgs.lib.nixosSystem
            {
              specialArgs = { inherit inputs outputs; };
              modules =
                [
                  ({ nixpkgs.overlays = overlays; })
                  ## PROGRAMS
                    lsfg-vk.nixosModules.default
                    aagl.nixosModules.default (import ./programs/agl.sys.nix)
                  ## FLATPAK
                    nix-flatpak.nixosModules.nix-flatpak
                  ## MEDIA
                  ## SECRETS
                    sops-nix.nixosModules.sops
                  ## THEMING
                    stylix.nixosModules.stylix (import ./theme/nxStylix.nix)
                  ## WINDOW MANAGERS
                    niri.nixosModules.niri
                    {
                      programs.niri =
                        {
                          enable = true;
                          package = inputs.niri.packages.x86_64-linux.niri-unstable;
                        };
                      niri-flake.cache.enable = true;
                    }
                  ## IMPORTS
                    ./hosts/meow/default.nix
                    ./hosts/meow/hardware.nix
                ];
            };
          "nyaa" = nixpkgs.lib.nixosSystem
            {
              modules =
                [
                  ## IMPORTS
                    ./hosts/server/default.nix
                    ./hosts/server/hardware.nix
                ];
            };
          "paperless-container" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ({ config, pkgs, ... }: {
                boot.isContainer = true;

                # Network configuration
                networking = {
                  hostName = "paperless";
                  useHostResolvConf = false;
                  firewall.allowedTCPPorts = [ 28981 ];
                };

                # System packages
                environment.systemPackages = with pkgs; [
                  vim
                  curl
                  htop
                ];

                # Paperless-ngx service
                services.paperless = {
                  enable = true;
                  address = "0.0.0.0";
                  port = 28981;

                  # Data directory
                  dataDir = "/var/lib/paperless";
                  mediaDir = "/var/lib/paperless/media";

                  # OCR language
                  settings = {
                    PAPERLESS_OCR_LANGUAGE = "eng";
                    PAPERLESS_ADMIN_USER = "admin";
                    PAPERLESS_ADMIN_PASSWORD = "changeme";
                    PAPERLESS_TIME_ZONE = "UTC";
                  };

                  # Optional: Enable Redis for better performance
                  consumptionDirIsPublic = false;
                };

                # Enable PostgreSQL (paperless uses it automatically)
                services.postgresql = {
                  enable = true;
                  package = pkgs.postgresql_15;
                };

                # Enable Redis for task queue
                services.redis.servers.paperless = {
                  enable = true;
                  port = 6379;
                };

                system.stateVersion = "24.05";
              })
            ];
          };
        };
    };
  }

/* vim: set fdm=manual */
