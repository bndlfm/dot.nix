{
  description = "Hyper-shell: A shell environment powered by AI";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python311;

        pythonWithPackages = python.withPackages (ps: with ps; [
          openai
          rich
          distro
        ]);

        configFile = pkgs.writeTextFile {
          name = "config.ini";
          text = ''
            [main]
            ai_service = openai
            # personality = 'not supported yet'

            [openai]

            # The openai key generated in your accounts, It has the format sk-0AABhhh1AA1...
            service_key = YOUR-OPENAI-KEY

            # Model that will handle the request; Be careful, changing it may impact consistently your bill.
            service_model = gpt-3.5-turbo

            [anthropic]

            service_key = YOUR-ANTHROPIC-KEY

            service_model = claude-v1

          '';
        };

        launcherScript = pkgs.writeShellScriptBin "hyper-shell" ''
          #!/usr/bin/env bash
          exec ${pythonWithPackages}/bin/python $out/share/hyper-shell/dodo.py "$@"
        '';

        fishConfig = { config, programs, ... }: {
          programs.fish = {
            shellAliases = programs.fish.shellAliases ++ {
              "dodo" = "python dodo.py";
              "hs" = "hyper-shell";
            };
            interactiveShellInit = ''
            '';
          };
          #home.file.".bin/hyper-shell".source = "${hyper-shell}/bin/hyper-shell";
        };

        hyper-shell = pkgs.stdenv.mkDerivation rec {
          pname = "hyper-shell";
          version = "0.1.0";  # You may want to update this to the latest version

          src = pkgs.fetchFromGitHub {
            owner = "kirabase";
            repo = "hyper-shell";
            rev = "master";
            hash = "sha256-ou9yKTR5PGsTR5LMxBIxRFxWFXYe739WXySnbzSSnTQ=";
          };

          nativeBuildInputs = [ pkgs.makeWrapper ];

          installPhase = ''
            mkdir -p $out/bin $out/share/${pname}
            cp -R ./* $out/share/${pname}
            cp ${configFile} $out/share/${pname}/config.ini

            # Create shell script
            #cat > $out/bin/hyper-shell <<EOF
            ##!/usr/bin/env bash
            #exec ${pythonWithPackages}/bin/python $out/share/${pname}/dodo.py "$@"
            #EOF

            #chmod +x $out/bin/hyper-shell

            #makeWrapper $out/bin/hyper-shell $out/bin/hyper-shell \
            #  --prefix PYTHONPATH : $out/share/${pname} \

            install -Dm755 ${launcherScript}/bin/hyper-shell $out/bin/hyper-shell

            for file in $out/share/${pname}/*.py; do
              if [ -f "$file" ]; then
                filename=$(basename "$file")
                makeWrapper ${pythonWithPackages}/bin/python $out/bin/''${filename%.py} \
                  --add-flags "$out/share/${pname}/$filename" \
                  --prefix PYTHONPATH : $out/share/${pname}
              fi
            done
          '';

          meta = with pkgs.lib; {
            description = "A shell environment powered by AI";
            homepage = "https://github.com/kirabase/hyper-shell";
            license = licenses.mit;  # Adjust if the license is different
            maintainers = with maintainers; [ ];  # Add maintainers if known
          };
        };


      in {
        packages.default = hyper-shell;

        homeManagerModules.default = fishConfig;

        # Optionally, you can also add a devShell
        devShells.default = pkgs.mkShell {
          buildInputs = [ hyper-shell pythonWithPackages ];
        };
      });
}
