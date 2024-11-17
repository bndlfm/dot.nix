{
  description = "A flake for packaging the WBFS file binary";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "wbfs_file";
          version = "1.4.0"; # Replace with the actual version

          src = pkgs.fetchzip {
            url = "https://gbatemp.net/download/wbfs_file.35275/download"; # Replace with the actual URL
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with the actual hash
          };

          installPhase = ''
            mkdir -p $out/bin
            cp linux/wbfs_file $out/bin/
            chmod +x $out/bin/wbfs_file
          '';

          meta = with pkgs.lib; {
            description = "WBFS file utility";
            homepage = "https://gbatemp.net/download/wbfs_file.35275/"; # Couldn't find original project.
            license = licenses.mit; # Replace with the actual license
            platforms = platforms.linux;
          };
        };
      }
    );
}

