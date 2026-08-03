{ pkgs, config, lib, ... }:
let
  noteCompanionSrc = pkgs.fetchFromGitHub {
    owner = "Nexus-JPF";
    repo = "note-companion";
    rev = "master";
    hash = "sha256-2huXM1TTSMLVw+Q8wHmPsP5Hlspnl7SAqEmReCnwrnw="; # Replace after first build
  };
  
  # Fetch dependencies but don't build - let the container build at startup
  noteCompanionDeps = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "note-companion-deps";
    version = "unstable";
    
    src = noteCompanionSrc;
    
    nativeBuildInputs = with pkgs; [
      nodejs_20
      pnpmConfigHook
      pnpm
    ];
    
    # Fetch pnpm dependencies
    pnpmDeps = pkgs.fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 3;
      hash = "sha256-U5IFfBXLPmbDihRcZIz7jao/gtpFG/kFma3yq+f6aEY="; # Replace after first build
    };
    
    # Just install dependencies, don't build
    dontBuild = true;
    
    # Install source and dependencies
    installPhase = ''
      runHook preInstall
      
      mkdir -p $out
      cp -r ${noteCompanionSrc}/* $out/
      cp -r node_modules $out/node_modules
      
      runHook postInstall
    '';
  });
  
  # Build the Docker image with source + deps, build at runtime
  noteCompanionImg = pkgs.dockerTools.buildLayeredImage {
    name = "note-companion";
    tag = "latest";

    contents = with pkgs; [
      nodejs_20
      pnpm
      bash
      coreutils
    ];
    
    extraCommands = ''
      # Copy app with dependencies
      mkdir -p ./app
      cp -r ${noteCompanionDeps}/* ./app/
    '';

    config = {
      WorkingDir = "/app/packages/web";
      # Build and start on container startup
      Cmd = [ 
        "${pkgs.bash}/bin/bash"
        "-c"
        "cd /app/packages/web && pnpm build:self-host && pnpm start"
      ];
      ExposedPorts = {
        "3010/tcp" = {};
      };
      Env = [
        "NODE_ENV=production"
        "PATH=${pkgs.nodejs_20}/bin:${pkgs.pnpm}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      ];
    };
  };
in {
  programs.obsidian.enable = true;

  services.podman = {
    enable = true;
    autoUpdate.enable = true;

    containers.note-companion = {
      image = "localhost/note-companion:latest";
      autoStart = true;

      ports = [ "3010:3010" ];

      environment = {
        OPENAI_API_KEY = "sk-your-key-here";
        NODE_ENV = "production";
      };

      volumes = [
        "note-companion-data:/app/data"
      ];

      extraConfig = {
        Container = {
          ImageFile = "${noteCompanionImg}";
        };
      };
    };
  };
}
