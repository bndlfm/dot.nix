{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    let
      pondSource = builtins.fetchGit {
        url = "https://github.com/bndlfm/pond.fish.git";
        ref = "refs/heads/feat/pond-3-acp-rewrite";
        rev = "7917f58d92ea10eec94fffefd946aba5c7a6b068";
      };
    in
    {
    ### FIXES
    hyprland = inputs.hyprland.packages.${prev.system}.hyprland;
    ucx = prev.ucx.override { enableCuda = false; };
    code-cursor = prev.code-cursor.overrideAttrs (oldAttrs: {
      postBuild = ''
        wrapProgram $out/bin/cursor --set ELECTRON_OZONE_PLATFORM_HINT X11
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
    fish = prev.fish.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        "${pondSource}/patches/fish-command-capture.patch"
      ];
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
