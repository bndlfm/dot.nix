{
   description = "My First (System) Flake (godspeed)";

   inputs = {
     nixpkgs.url = "nixpkgs/nixos-unstable";
     home-manager = {
       url = "github:n-hass/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
       };
     };

   outputs = { self, nixpkgs, home-manager, ... }@inputs: {
     nixosConfigurations.meow = nixpkgs.lib.nixosSystem {
       #specialArgs.inputs = inputs;
       system = "x86_64-linux";
       modules = [
         ./configuration.nix
         home-manager.nixosModules.home-manager
         #<sops-nix/modules/sops>
         #({ pkgs, home-manager, ... }: {
         #  users.users.neko = {
         #    isNormalUser = true;
         #    home-manager.enable = true;
         #    };
         #  })
         ];
       };
     };
}
