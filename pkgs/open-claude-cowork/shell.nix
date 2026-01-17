{ pkgs ? import <nixpkgs> {} }:

let
  app = import ./default.nix { inherit pkgs; };

  # Development script
  devSetup = pkgs.writeShellScriptBin "nix-setup" ''
    if [ ! -f .env ]; then
        cp .env.example .env
        echo "Created .env. Please configure API keys."
    fi
    
    echo "Installing dependencies..."
    npm install
    cd server && npm install && cd ..
    
    echo "Checking for Composio..."
    if ! command -v composio &> /dev/null; then
        echo "Composio CLI not found in path (unexpected in this shell)."
    else
        echo "Composio CLI is available."
    fi
    
    echo "Done. Run 'start-app' to develop."
  '';

  startDev = pkgs.writeShellScriptBin "start-app" ''
      cd server && npm start &
      SERVER_PID=$!
      sleep 2
      cd .. && npm start
      kill $SERVER_PID
  '';

in
pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs
    electron
    python3
    pkg-config
    libsecret
    app.composio-cli
    devSetup
    startDev
  ];
  
  shellHook = ''
    export ELECTRON_OVERRIDE_DIST_PATH="${pkgs.electron}/bin"
    export ELECTRON_SKIP_BINARY_DOWNLOAD=1
    
    echo "Open Claude Cowork Dev Environment (nix-shell)"
    echo "Run 'nix-setup' to install local npm deps."
    echo "Run 'start-app' to launch in dev mode."
  '';
}
