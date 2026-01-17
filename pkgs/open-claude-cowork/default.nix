{ pkgs ? import <nixpkgs> {}, config }:
let
  envFile = pkgs.writeText ".env" ''
    # Claude Provider
    ANTHROPIC_API_KEY=${builtins.getEnv "ANTHROPIC_API_KEY"}

    # Opencode Provider (optional)
    OPENCODE_API_KEY=${builtins.getEnv "OPENCODE_API_KEY"}
    OPENCODE_HOSTNAME=127.0.0.1
    OPENCODE_PORT=4096

    # Composio Integration
    COMPOSIO_API_KEY=${builtins.getEnv "COMPOSIO_API_KEY"}
  '';

  repo = pkgs.fetchFromGitHub {
    owner = "ComposioHQ";
    repo = "open-claude-cowork";
    rev = "master"; # or use a specific commit hash for reproducibility
    sha256 = "sha256-SyBVMaF7z6513HJ1vWV4R89g1gzJsomM3yopf7RZxzg="; # You'll need to fill this in after first build attempt
  };

  composio-cli = pkgs.stdenv.mkDerivation rec {
    pname = "composio-cli";
    version = "v0.9.5-rc.1";
    src = pkgs.fetchurl {
      url = "https://github.com/ComposioHQ/composio/releases/download/${version}/composio-linux-x64.zip";
      sha256 = "2b684993d0766e4b96a7057a0818b568d8cd5a3c0523c10407cb3fb39d1aff33";
    };
    nativeBuildInputs = [ pkgs.unzip pkgs.makeWrapper ];
    unpackPhase = ''
      unzip $src
    '';
    installPhase = ''
      mkdir -p $out/bin
      install -m755 composio $out/bin/composio
    '';
  };

  backend = pkgs.buildNpmPackage {
    pname = "open-claude-cowork-server";
    version = "1.0.0";
    src = "${repo}/server";

    npmDepsHash = "sha256-iRGzqvc99hM8VET4Nd6VUQyrj2az7qoPNe9DLrIqkG0=";
    dontNpmBuild = true;
    makeCacheWritable = true;
    npmFlags = [ "--legacy-peer-deps" ];
    nativeBuildInputs = [ pkgs.makeWrapper ];

    postInstall = ''
      mkdir -p $out/bin

      cp ${envFile} $out/lib/node_modules/claude-agent-backend/.env

      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/open-claude-cowork-server \
        --add-flags "$out/lib/node_modules/claude-agent-backend/server.js" \
        --set NODE_ENV production
    '';
  };

  frontend = pkgs.buildNpmPackage {
    pname = "open-claude-cowork";
    version = "1.0.0";
    src = repo;

    npmDepsHash = "sha256-SyBVMaF7z6513HJ1vWV4R89g1gzJsomM3yopf7RZxzg=";
    dontNpmBuild = true;
    makeCacheWritable = true;
    npmFlags = [ "--legacy-peer-deps" ];

    nativeBuildInputs = [ pkgs.makeWrapper ];

    env = {
      ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    };

    postInstall = ''
      mkdir -p $out/share/open-claude-cowork
      cp -r . $out/share/open-claude-cowork

      cp ${envFile} $out/share/open-claude-cowork/.env

      rm -rf $out/share/open-claude-cowork/server

      mkdir -p $out/bin
      makeWrapper ${pkgs.electron}/bin/electron $out/bin/open-claude-cowork-client \
        --add-flags "$out/share/open-claude-cowork/main.js" \
        --set NODE_ENV production
    '';
  };

  app = pkgs.writeShellScriptBin "open-claude-cowork" ''
    # Kill child processes on exit
    trap 'kill $(jobs -p) 2>/dev/null' EXIT

    ${backend}/bin/open-claude-cowork-server &
    SERVER_PID=$!

    sleep 2

    ${frontend}/bin/open-claude-cowork-client "$@"
  '';
  in
    app // {
      inherit backend frontend composio-cli;
    }
