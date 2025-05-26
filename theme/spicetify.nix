{ inputs, pkgs, ... }:{
  programs.spicetify =
    let
      system = "x86_64-linux";
      spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
      spotx = pkgs.fetchurl {
        url = "https://github.com/SpotX-Official/SpotX-Bash/raw/d756a3f23ddd8bbbeb644f6070a147aaa239ba4a/spotx.sh";
        hash = "sha256-7YW4yaIgamuKrdKpjPEwFqnCWX+9pGvvVYvwGySR9VA=";
      };
      spotifyVersion = "1.2.59.514.g834e17d4";
      rev = "86";
    in {
      enable = true;
      spotifyPackage =
        pkgs.spotify.overrideAttrs (old: {
          version = spotifyVersion;
          src = pkgs.fetchurl {
            name = "spotify-${spotifyVersion}-${rev}.snap";
            url = "https://api.snapcraft.io/api/v1/snaps/download/pOBIoZ2LrCB3rDohMxoYGnbN14EHOgD7_${rev}.snap";
            hash = "sha512-b9VlPwZ6JJ7Kt2p0ji1qtTJQHZE9d4KBO3iqQwsYh6k+ljtV/mSdinZi+B//Yb+KXhMErd0oaVzIpCCMqft6FQ==";
          };
          nativeBuildInputs =
            old.nativeBuildInputs
            ++ (with pkgs; [
              util-linux
              perl
              unzip
              zip
              curl
            ]);

          unpackPhase =
            builtins.replaceStrings
              [ "runHook postUnpack" ]
              [
                ''
                  patchShebangs --build ${spotx}
                  runHook postUnpack
                ''
              ]
              old.unpackPhase;

          installPhase =
            builtins.replaceStrings
              [ "runHook postInstall" ]
              [
                ''
                  bash ${spotx} -f -P "$out/share/spotify"
                  runHook postInstall
                ''
              ]
              old.installPhase;
        });
      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        hidePodcasts
      ];
      theme = spicePkgs.themes.dribbblishDynamic;
      colorScheme = "Base";
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
      ];
    };
}
