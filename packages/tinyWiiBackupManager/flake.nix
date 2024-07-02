{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.tiny-wii-backup-manager = builtins.callPackage ./tiny-wii-backup-manager.nix {};

    packages.x86_64-linux.default = self.packages.x86_64-linux.tiny-wii-backup-manager;

  };
}
