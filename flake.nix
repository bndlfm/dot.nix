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
    #deejavu.url = "github:bndlfm/deejavu";
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
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    ## VIRTUALIZATION
    microvm = {
      url = "github:astro/microvm.nix";
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

      microvm,

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
    rec {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      container = {
        openclaw-gateway =
          nixosConfigurations.meow.config.containers."openclaw-gateway".config.system.build.toplevel;
      };
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
            (import ./services/flatpak.home.nix)
            ## NIRI
            niri.homeModules.niri
            ## THEMING
            stylix.homeModules.stylix
            (import ./blocks/theme/hmStylix.nix)
            ## ZEN BROWSER
            inputs.zen-browser.homeModules.twilight
            (import ./programs/zen-browser.home.nix)

            ## MODULES
            outputs.homeManagerModules.wlr-which-key
            (import ./blocks/music.home.nix)
            #(import ./blocks/notes.home.nix)

            ## PROGRAMS
            (import ./programs/programs.home.nix)
            (import ./programs/email.home.nix)
            (import ./programs/shell/default.nix)
            (import ./blocks/shell/zellij.home.nix)
            (import ./programs/twitch.home.nix)
            (import ./programs/firefox.home.nix)
            (import ./programs/git.home.nix)
            (import ./programs/neovim.home.nix)
            (import ./programs/password-store.home.nix)
            (import ./programs/ranger.home.nix)
            (import ./programs/yazi.home.nix)

            ## SECRETS
            inputs.sops-nix.homeManagerModules.sops
            (import ./sops/sops.home.nix)

            ## SERVICES
            (import ./services/espanso.home.nix)
            (import ./services/services.home.nix)

            ## SPOTIFY
            inputs.spicetify-nix.homeManagerModules.default

            ## WINDOW MANAGERS
            (import ./programs/gnome-shell.home.nix)
            (import ./blocks/wm/hyprland.home.nix)
            (import ./blocks/wm/niri.home.nix)
            (import ./blocks/wm/wlr-which-key.home.nix)

            ## CONTAINERS
            (import ./containers/gluetun.home.nix)

            ## IMPORTS
            ./home/neko/default.nix
          ];
        };

        "ceru@server" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux.appendOverlays overlays;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ## PROGRAMS
            (import ./programs/shell/default.nix)
            (import ./programs/neovim.home.nix)

            ## CONTAINERS
            (import ./containers/homeassistant.home.nix)

            ## SECRETS
            inputs.sops-nix.homeManagerModules.sops
            (import ./sops/sops.home.nix)

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
            ## THEMING
            stylix.nixosModules.stylix
            (import ./blocks/theme/nxStylix.nix)
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

            ## MODULES
            (import ./blocks/caddy-tailscale.sys.nix)
            (import ./blocks/mympd.sys.nix)
            (import ./blocks/gaming.sys.nix)
            inputs.nixarr.nixosModules.default
            (import ./blocks/nixarr.sys.nix)

            ## SECRETS
            inputs.sops-nix.nixosModules.sops
            (import ./sops/sops.sys.nix)

            ## SERVICES
            (import ./services/sunshine.sys.nix)
            (import ./services/vaultwarden.sys.nix)

            ## WINDOW MANAGERS
            (import ./blocks/wm/hyprland.sys.nix)

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
      };
    };
}
