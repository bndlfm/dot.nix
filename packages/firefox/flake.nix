# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs";
  };

  outputs = {self, nixpkgs }: {
    firefox-devedition-patched = nixpkgs.makeWrapper {
      name = "firefox-memCache";
      buildInputs = [
        nixpkgs.zip
        nixpkgs.unzip
      ];

      postPatch = ''
        set -ex
        cd $out

        # Extract browser components.
        tar -xf browser.tar.bz2
        tar -xf comm-central.tar.bz2

        # Apply patches.
        patch -p1 -i "$(echo $patches | tr ' ' '\n')"

        # Repackage browser components.
        tar -cjf browser.tar.bz2 browser
        tar -cjf comm-central.tar.bz2 comm-central

        # Remove extracted components.
        rm -rf browser comm-central
      '';

      patches = [
        ./patches/ext-tabs.js.patch
        ./patches/tabs.json.patch
        ];
      };
    };
}
