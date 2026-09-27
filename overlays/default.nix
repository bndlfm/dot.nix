{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {
    pkgs = final.pkgs;
    wnv-src = inputs.waydroid-nvidia-src;
  };

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
    wivrn = prev.wivrn.overrideAttrs (old: let
      wivrnVersion = "26.9";
      wivrnSource = final.fetchFromGitHub {
        owner = "wivrn";
        repo = "wivrn";
        rev = "v${wivrnVersion}";
        hash = "sha256-/kXgbku/4EeYY5YTwtY71csgxOP8bRACLqOvKXolg5g=";
      };
    in {
      version = wivrnVersion;
      src = wivrnSource;
      monado = final.applyPatches {
        src = final.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "monado";
          repo = "monado";
          rev = "f037264d23e2472a444a157370647fcd601ed81b";
          hash = "sha256-exHbecudAy57szL7kut7/fBYCoekEs3riZzhMtFWS/c=";
        };
        postPatch = ''
          ${wivrnSource}/patches/apply.sh ${wivrnSource}/patches/monado/*
        '';
      };
      buildInputs = final.lib.filter (input: input != final.libpulseaudio) old.buildInputs;
      cmakeFlags = (final.lib.filter (flag:
        !(final.lib.hasPrefix "-DGIT_DESC:" flag)
        && !(final.lib.hasPrefix "-DGIT_COMMIT:" flag)
        && !(final.lib.hasPrefix "-DWIVRN_USE_PULSEAUDIO:" flag)
      ) old.cmakeFlags) ++ [
        (final.lib.cmakeFeature "GIT_TAG" "v${wivrnVersion}")
      ];
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
