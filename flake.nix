{
  inputs = {
    #********************
    #* PERMANENT INPUTS *
    #********************
    ## NIX
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
    nixarr.url = "github:bndlfm/nixarr/main";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix?rev=f0595e3b59260457042450749eaec00a5a47db35";

    ## PROGRAMS
    hermes-agent.url = "github:NousResearch/hermes-agent";
    claude-cowork-nix.url = "github:Reginleif88/claude-cowork-nix";
    #deejavu.url = "github:bndlfm/deejavu";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
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

    ## VIRTUALIZATION
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## JOVIAN
    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## CACHY / HANDHELD KERNEL
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      nix-flatpak,

      lsfg-vk,
      nixarr,

      hyprland,
      niri,

      hermes-agent,
      claude-cowork-nix,
      nixCats,

      microvm,

      jovian-nixos,
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
      overlays = with (import ./overlays { inherit inputs; }); [
        additions
        modifications
        nixpkgs-stable
        nixpkgs-bndlfm
        inputs.niri.overlays.niri
      ];
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      #*********************#
      # HOME CONFIGURATIONS #
      #*********************#
      homeConfigurations = {
        "neko@meow" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux.appendOverlays overlays;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ## CACHES
            ./cachix.nix
            ## FLATPAK
            nix-flatpak.homeManagerModules.nix-flatpak
            ./modules/home-manager/flatpak.home.nix
            ## THEMING
            stylix.homeModules.stylix
            ./modules/theme/hmStylix.nix

            ## ZEN BROWSER
            inputs.zen-browser.homeModules.twilight
            ./modules/home-manager/zen-browser.home.nix

            ## MODULES
            outputs.homeManagerModules.wlr-which-key
            ./modules/home-manager/music.home.nix
            #./modules/notes.home.nix

            ## PROGRAMS
            ./modules/home-manager/programs.home.nix
            ./modules/home-manager/email.home.nix
            ./modules/home-manager/firefox.home.nix
            ./modules/home-manager/git.home.nix
            ./modules/home-manager/nixcats/nixcats.home.nix
            ./modules/home-manager/password-store.home.nix
            ./modules/home-manager/ranger.home.nix
            ./modules/home-manager/shell/default.nix
            ./modules/home-manager/twitch.home.nix
            ./modules/home-manager/yazi.home.nix

            ## SECRETS
            inputs.sops-nix.homeManagerModules.sops
            ./sops/sops.home.nix

            ## SERVICES
            ./modules/home-manager/espanso.home.nix
            ./modules/home-manager/services.home.nix

            ## SPOTIFY
            inputs.spicetify-nix.homeManagerModules.default

            ## WINDOW MANAGERS
            niri.homeModules.niri
            ./modules/wm/hyprland-lua.home.nix
            ./modules/wm/niri.home.nix
            ./modules/wm/wlr-which-key.home.nix

            ## CONTAINERS
            ./containers/gluetun.home.nix

            ## IMPORTS
            ./home/neko/default.nix
          ];
        };

        "ceru@server" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux.appendOverlays overlays;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ## PROGRAMS
            ./modules/home-manager/shell/default.nix
            ./modules/home-manager/nixcats/nixcats.home.nix
            ./modules/home-manager/yazi.home.nix

            ## CONTAINERS
            ./containers/homeassistant.home.nix

            ## SECRETS
            inputs.sops-nix.homeManagerModules.sops
            ./sops/sops.home.nix

            ## IMPORTS
            ./home/ceru/default.nix
          ];
        };
      };

      #**********************#
      # NIXOS CONFIGURATIONS #
      #**********************#
      nixosConfigurations = {
        "meow" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ({ nixpkgs.overlays = overlays; })
            ## CACHES
            ./cachix.nix
            ## PROGRAMS
            lsfg-vk.nixosModules.default
            ## FLATPAK
            nix-flatpak.nixosModules.nix-flatpak

            ## MODULES
            ./modules/nixos/caddy-tailscale.sys.nix
            ./modules/nixos/gaming
            inputs.nixarr.nixosModules.default
            ./modules/nixos/nixarr.sys.nix

            ## THEMING
            stylix.nixosModules.stylix
            ./modules/theme/nxStylix.nix

            ## SECRETS
            inputs.sops-nix.nixosModules.sops
            ./sops/sops.sys.nix

            ## SERVICES
            ./modules/nixos/sunshine.sys.nix
            ./modules/nixos/vaultwarden.sys.nix
            ./modules/nixos/synergy.sys.nix

            ## WINDOW MANAGERS
            niri.nixosModules.niri
            (
              { pkgs, ... }:
              {
                programs.niri = {
                  enable = true;
                  package = pkgs.niri-unstable;
                };
                niri-flake.cache.enable = true;
              }
            )
            ./modules/wm/hyprland.sys.nix

            ## IMPORTS
            ./hosts/meow/default.nix
            ./hosts/meow/hardware.nix
          ];
        };
        "server" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ## IMPORTS
            ./hosts/server/default.nix
            ./hosts/server/hardware.nix
          ];
        };
        "ally" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ({ nixpkgs.overlays = overlays; })
            ## CACHES
            ./cachix.nix
            ## HOME MANAGER / NEOVIM
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs outputs; };
                users.neko = {
                  imports = [ ./modules/home-manager/nixcats/nixcats.home.nix ];
                  home.stateVersion = "23.11";
                };
              };
            }
            ## JOVIAN
            jovian-nixos.nixosModules.default
            ## CHAOTIC / CACHY KERNEL
            inputs.chaotic.nixosModules.default
            ## SECRETS
            inputs.sops-nix.nixosModules.sops
            ./sops/sops.sys.nix
            ## MODULES
            ./modules/nixos/gaming/gaming.sys.nix
            ./modules/nixos/sunshine.sys.nix
            ./modules/nixos/tailscale.sys.nix
            ## IMPORTS
            ./hosts/ally/default.nix
            ./hosts/ally/hardware.nix
          ];
        };
      };
    };
}
