{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    ### FIXES
    ucx = prev.ucx.override { enableCuda = false; };
    openclaw = prev.openclaw.overrideAttrs (oldAttrs: {
      pnpmDeps = oldAttrs.pnpmDeps.overrideAttrs (_: {
        outputHash = "sha256-k+vO+D4tj/uRuMsKTUEgYLjvEgzMMh8F4fQ7DhIROMw=";
      });
    });
    
    ### RANDOM
    hermes-agent = (inputs.hermes-agent.packages.${prev.system}.default.override {
      extraPythonPackages = [
        (final.python312Packages.buildPythonPackage {
          pname = "hermes-agent-manifests";
          version = "1.0.0";
          src = inputs.hermes-agent.outPath;
          format = "other";
          installPhase = ''
            site_packages=$out/lib/python3.12/site-packages
            find plugins -name "plugin.yaml" -o -name "plugin.yml" | while read -r f; do
              dest="$site_packages/$(dirname "$f")"
              mkdir -p "$dest"
              cp "$f" "$dest/"
            done
          '';
        })
      ];
    }).overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        rm $out/share/hermes-agent/plugins
        cp -r ${inputs.hermes-agent.outPath}/plugins $out/share/hermes-agent/plugins
        chmod -R +w $out/share/hermes-agent/plugins
        substituteInPlace $out/share/hermes-agent/plugins/platforms/discord/adapter.py \
          --replace-fail 'opus_path = ctypes.util.find_library("opus")' 'opus_path = "${final.libopus}/lib/libopus.so"'
      '';
    });
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
