{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    spotify = let
      spotx = prev.fetchurl {
        url = "https://github.com/SpotX-Official/SpotX-Bash/raw/d756a3f23ddd8bbbeb644f6070a147aaa239ba4a/spotx.sh";
        hash = "sha256-7YW4yaIgamuKrdKpjPEwFqnCWX+9pGvvVYvwGySR9VA=";
      };
    in
      prev.spotify.overrideAttrs (old: {
        nativeBuildInputs =
          old.nativeBuildInputs
          ++ (with prev; [
            util-linux
            perl
            unzip
            zip
            curl
          ]);

        unpackPhase = builtins.replaceStrings
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
  };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  nixpkgs-stable = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  nixpkgs-bndlfm = final: _prev: {
    bndlfm = import inputs.nixpkgs-bndlfm {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
