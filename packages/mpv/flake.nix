{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    packages.default = nixpkgs.legacyPackages.x86_64-linux.mpv;
    };
}
