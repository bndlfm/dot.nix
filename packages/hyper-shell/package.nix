{ config, pkgs, ... }:

let
  python = pkgs.python311;
  pythonWithPackages = python.withPackages (ps: with ps; [
    openai
    rich
    distro
  ]);

  hyper-shell = pkgs.stdenv.mkDerivation rec {
    pname = "hyper-shell";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "kirabase";
      repo = "hyper-shell";
      rev = "master";
      hash = "sha256-ou9yKTR5PGsTR5LMxBIxRFxWFXYe739WXySnbzSSnTQ=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = /* sh */ ''
      mkdir -p $out/bin $out/share/${pname}
      cp -R ./* $out/share/${pname}
      cp ${configFile} $out/share/${pname}/config.ini
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

  configFile = pkgs.writeTextFile {
    name = "config.ini";
    text = ''
      [main]
      ai_service = openai
      # personality = 'not supported yet'
      [openai]
      # The openai key generated in your accounts, It has the format sk-0AABhhh1AA1...
      service_key = ${config.sops.secrets."hyper-shell".path}
      # Model that will handle the request; Be careful, changing it may impact consistently your bill.
      service_model = gpt-3.5-turbo
      [anthropic]
      service_key = INSERT_API_KEY_HERE
      service_model = claude-sonnet-v3.5
    '';
  };

in
{
  # Define the package
  environment.systemPackages = [ hyper-shell ];

  # sops-nix configuration
  sops.secrets.openai_api_key = {
    sopsFile = ./secrets.yaml;
  };

  sops.secrets.anthropic_api_key = {
    sopsFile = ./secrets.yaml;
  };

  # You may want to add more configuration options here, such as:
  # - Service definition if hyper-shell should run as a service
  # - Any additional system configuration required for hyper-shell to function properly
}
