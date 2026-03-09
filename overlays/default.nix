{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    ### RANDOM
    code-cursor = prev.code-cursor.overrideAttrs (oldAttrs: {
      postBuild = ''
        wrapProgram $out/bin/cursor --set ELECTRON_OZONE_PLATFORM_HINT X11
      '';
    });
    gemini-cli = prev.gemini-cli.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.makeWrapper ];
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/gemini \
          --prefix PATH : ${final.lib.makeBinPath [ final.nodejs_22 ]}
      '';
    });
    wivrn = prev.wivrn.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        for bin in wivrnctl wivrn-dashboard wivrn-server; do
          if [ -e $out/bin/$bin ]; then
            wrapProgram $out/bin/$bin \
              --prefix PATH : ${final.lib.makeBinPath [ final.android-tools ]}
          fi
        done
      '';
    });

    # GO FIXES
    caddy = prev.caddy.overrideAttrs (old: {
      nativeBuildInputs =
        builtins.filter (p: !(p ? pname && p.pname == "go")) (old.nativeBuildInputs or [ ])
        ++ [ final.go_1_26 ];
    });
    trayscale = prev.trayscale.overrideAttrs (old: {
      nativeBuildInputs =
        builtins.filter (p: !(p ? pname && p.pname == "go")) (old.nativeBuildInputs or [ ])
        ++ [ final.go_1_25 ];
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
