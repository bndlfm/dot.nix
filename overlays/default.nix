{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    #wivrn = prev.wivrn.overrideAttrs (oldAttrs: rec {
    #  version = "25.11.1";
    #  src = final.fetchFromGitHub {
    #    owner = "WiVRn";
    #    repo = "WiVRn";
    #    rev = "v${version}";
    #    hash = "sha256-pEKMeRdI9UhdZ+NksRBcF7yPC7Ys2haE+B4PPGQ4beE=";  # Replace with actual hash
    #    fetchSubmodules = true;
    #  };
    #});
    code-cursor = prev.code-cursor.overrideAttrs (oldAttrs: rec {
      postBuild = ''
        wrapProgram $out/bin/cursor --set ELECTRON_OZONE_PLATFORM_HINT X11
      '';
    });
    sunshine = final.stable.sunshine;
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
