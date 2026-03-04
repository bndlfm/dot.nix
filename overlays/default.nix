{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    code-cursor = prev.code-cursor.overrideAttrs (oldAttrs: {
      postBuild = ''
        wrapProgram $out/bin/cursor --set ELECTRON_OZONE_PLATFORM_HINT X11
      '';
    });

    sunshine = final.stable.sunshine;
    calibre = final.stable.calibre;

    gemini-cli = prev.gemini-cli.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.makeWrapper ];
      postBuild = (old.postBuild or "") + ''
        wrapProgram $out/bin/gemini --prefix PATH : ${final.lib.makeBinPath [ final.nodejs_22 ]}
      '';
    });

    wivrn = prev.wivrn.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.makeWrapper ];
      postBuild = (old.postBuild or "") + ''
        for bin in wivrnctl wivrn-dashboard wivrn-server; do
          if [ -e $out/bin/$bin ]; then
            wrapProgram $out/bin/$bin --prefix PATH : ${final.lib.makeBinPath [ final.android-tools ]}
          fi
        done
      '';
    });

    python3 = prev.python3.override {
      packageOverrides = pyFinal: pyPrev: {
        plotly = pyPrev.plotly.overrideAttrs (_: {
          doCheck = false;
        });
      };
    };
    python3Packages = final.python3.pkgs;

    niri-unstable =
      let
        unstablePkg = inputs.niri.packages.${final.system}.niri-unstable;
        patchedSrc = final.applyPatches {
          name = "${unstablePkg.pname or "niri-unstable"}-patched-src-${unstablePkg.version}";
          src = unstablePkg.src;
          patches = [
            (final.fetchpatch {
              url = "https://github.com/niri-wm/niri/pull/3483.patch";
              hash = "sha256-QFT7NRhq8TYaqba6BzPSpm35VthDuNIjH2e4oNsnoQU=";
            })
          ];
        };
      in
      unstablePkg.overrideAttrs (old: {
        src = patchedSrc;
        cargoDeps = final.rustPlatform.fetchCargoVendor {
          pname = old.pname or "niri-unstable";
          inherit (old) version;
          src = patchedSrc;
          hash = "sha256-uo4AWT4nGV56iiSLhXK30goI7HCPc7AUZjRLgUvLfUE=";
        };
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
