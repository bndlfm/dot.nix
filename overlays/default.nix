{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    code-cursor = prev.code-cursor.overrideAttrs (oldAttrs: rec {
      postBuild = ''
        wrapProgram $out/bin/cursor --set ELECTRON_OZONE_PLATFORM_HINT X11
      '';
    });
<<<<<<< HEAD
    sunshine = final.stable.sunshine;
=======
    python3 = prev.python3.override {
      packageOverrides = pyFinal: pyPrev: {
        plotly = pyPrev.plotly.overrideAttrs (_: {
          doCheck = false;
        });
      };
    };
    python3Packages = final.python3.pkgs;
>>>>>>> 43f9121da7c6d7c0b1ac7169332eaeb0be76af66
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
