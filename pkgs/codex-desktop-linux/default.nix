{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, makeWrapper
, p7zip
, nodejs
, nodePackages
, python3
, electron
, buildNpmPackage
, autoPatchelfHook
}:

let
  pname = "codex-desktop-linux";
  version = "26.305.950";

  dmg = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/Codex.dmg";
    hash = "sha256-4oKdhkRmwUbvnexeguuwfv+oRHhR3WYbUwewB9rpLDc=";
  };

  # Statically linked codex-cli binary from npm
  codex-cli = stdenv.mkDerivation rec {
    pname = "codex-cli";
    version = "0.112.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/@openai/codex/-/codex-${version}-linux-x64.tgz";
      hash = "sha256-WCeXsmiZuw48VCxruyGqQ3J/LXZbkv3szRZQORMPj54=";
    };
    nativeBuildInputs = [ p7zip ];
    unpackPhase = "7z x $src && tar -xf *.tar";
    installPhase = ''
      mkdir -p $out/bin
      cp package/vendor/x86_64-unknown-linux-musl/codex/codex $out/bin/codex
      chmod +x $out/bin/codex
    '';
  };

  # Rebuild native modules for Linux and Electron 40
  nativeModules = buildNpmPackage {
    pname = "${pname}-native-modules";
    inherit version;

    src = lib.cleanSourceWith {
      src = ./.;
      filter = name: type:
        let baseName = baseNameOf (toString name);
        in (baseName == "package.json" || baseName == "package-lock.json");
    };

    npmDepsHash = "sha256-8fbW1eM2ilhzj6hmdu0qDqZpVUGiGIUmAif+ZyKIYCY=";

    makeCacheWritable = true;
    npmInstallFlags = [ "--ignore-scripts" ];
    npmFlags = [ "--ignore-scripts" ];
    dontNpmBuild = true;

    nativeBuildInputs = [ nodejs.python ];
    
    # Electron version to rebuild for
    postBuild = ''
      npm_config_nodedir=${electron.headers} npm exec -- @electron/rebuild -v ${electron.version} -f
    '';

    installPhase = ''
      mkdir -p $out/node_modules
      cp -r node_modules/better-sqlite3 $out/node_modules/
      cp -r node_modules/node-pty $out/node_modules/
    '';
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ilysenko";
    repo = "codex-desktop-linux";
    rev = "dd18ce945bca4305bf03c63e9955a9845e0240b4";
    hash = "sha256-Rce6fJnFL1SUzOmvvS1QRAf1L+UrJfo/ziFoU8xMbA4=";
  };

  nativeBuildInputs = [ p7zip nodePackages.asar makeWrapper ];

  buildPhase = ''
    runHook preBuild

    7z x -y ${dmg} -oextracted-dmg || [ $? -eq 2 ]
    APP_ASAR=$(find extracted-dmg -name "app.asar" | head -1)
    asar extract "$APP_ASAR" app-extracted

    # Patch asar (remove macOS-only modules)
    rm -rf app-extracted/node_modules/sparkle-darwin
    find app-extracted -name "sparkle.node" -delete

    # Replace native modules with Linux versions
    rm -rf app-extracted/node_modules/better-sqlite3
    rm -rf app-extracted/node_modules/node-pty
    cp -r ${nativeModules}/node_modules/better-sqlite3 app-extracted/node_modules/
    cp -r ${nativeModules}/node_modules/node-pty app-extracted/node_modules/

    # Repack
    asar pack app-extracted app.asar --unpack "{*.node,*.so,*.dylib}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${pname}
    cp app.asar $out/share/${pname}/app.asar
    cp app-extracted/package.json $out/share/${pname}/package.json
    if [ -d app.asar.unpacked ]; then
      cp -r app.asar.unpacked $out/share/${pname}/app.asar.unpacked
    fi

    mkdir -p $out/share/${pname}/content/webview
    if [ -d app-extracted/webview ]; then
      cp -r app-extracted/webview/* $out/share/${pname}/content/webview/
    fi

    # Wrapper script that starts the Python server
    mkdir -p $out/bin
    cat > $out/bin/${pname} <<EOF
#!/bin/bash
set -e

WEBVIEW_DIR="$out/share/${pname}/content/webview"

# Try to start python server on port 5175 if webview files exist
if [ -d "\$WEBVIEW_DIR" ] && [ "\$(ls -A "\$WEBVIEW_DIR" 2>/dev/null)" ]; then
    echo "Starting webview server..."
    ${python3}/bin/python3 -m http.server 5175 --directory "\$WEBVIEW_DIR" &> /dev/null &
    HTTP_PID=\$!
    trap "kill \$HTTP_PID 2>/dev/null" EXIT
fi

# Use the bundled CLI or system one
export CODEX_CLI_PATH="''${CODEX_CLI_PATH:-${codex-cli}/bin/codex}"
export BUILD_FLAVOR=prod

${electron}/bin/electron "$out/share/${pname}/app.asar" --no-sandbox "\$@"
kill \$HTTP_PID 2>/dev/null || true
EOF
    chmod +x $out/bin/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unofficial OpenAI Codex Desktop app for Linux (macOS repackage)";
    homepage = "https://github.com/ilysenko/codex-desktop-linux";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = pname;
  };
}
