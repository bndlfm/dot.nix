{ lib
, stdenv
, fetchPnpmDeps
, fetchFromGitHub
, nodejs_22
, pnpm
, pnpmConfigHook
, python3
, pkg-config
, vips
, sqlite
, openssl
, homebrewRev ? "master"
, homebrewHash ? "sha256-/ZPWV/RjvRM3uuFgeP/ZJQRsGQEJ84yUxKE7M9/oeek="
, moltbotRev ? "master"
, moltbotHash ? "sha256-pMC5/y/NiW3ko7ZLdX7Hug6uMYlUWu89hl3vmoMRf00="
}:

let
  src = fetchFromGitHub {
    owner = "moltbot";
    repo = "moltbot";
    rev = moltbotRev;
    hash = moltbotHash;
  };
  homebrewSrc = fetchFromGitHub {
    owner = "Homebrew";
    repo = "brew";
    rev = homebrewRev;
    hash = homebrewHash;
  };
  homebrew = stdenv.mkDerivation {
    pname = "homebrew";
    version = homebrewRev;
    src = homebrewSrc;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -R . "$out/"
      runHook postInstall
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "moltbot";
  version = (lib.importJSON "${src}/package.json").version;
  inherit src;

  pnpmDepsHash = "sha256-lFaK7/9i+BT47PJF37LBxK3ARgHY/+yIJjimsOG5Mn8=";
  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    lockfile = "${src}/pnpm-lock.yaml";
    hash = pnpmDepsHash;
    fetcherVersion = 3;
  };

  nativeBuildInputs = [
    pnpm
    nodejs_22
    python3
    pkg-config
    pnpmConfigHook
    homebrew
  ];

  buildInputs = [
    vips
    sqlite
    openssl
  ];

  npmConfigPython = python3;

  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  PUPPETEER_SKIP_DOWNLOAD = "1";
  configurePhase = ''
    runHook preConfigure
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/lib/node_modules/${pname}
    cp -R \
      dist \
      assets \
      docs \
      extensions \
      patches \
      skills \
      git-hooks \
      scripts \
      ui \
      package.json \
      README.md \
      README-header.png \
      CHANGELOG.md \
      LICENSE \
      $out/lib/node_modules/${pname}/

    cp -R node_modules $out/lib/node_modules/${pname}/

    install -d $out/bin
    cat > $out/bin/moltbot <<'EOF'
    #!${stdenv.shell}
    set -euo pipefail
    if [ -n "''${XDG_DATA_HOME:-}" ]; then
      brew_home="''${XDG_DATA_HOME}/.clawdbot/homebrew"
    else
      brew_home="''${HOME}/.clawdbot/homebrew"
    fi

    export HOMEBREW_PREFIX="''${HOMEBREW_PREFIX:-$brew_home}"
    export HOMEBREW_REPOSITORY="''${HOMEBREW_REPOSITORY:-$brew_home}"
    export HOMEBREW_CELLAR="''${HOMEBREW_CELLAR:-$brew_home/Cellar}"

    if [ ! -d "$brew_home/Library" ]; then
      mkdir -p "$brew_home"
      cp -R ${homebrew}/* "$brew_home/"
    fi

    export PATH="${lib.makeBinPath [ homebrew pnpm ]}:$PATH"
    script_dir="$(cd "$(dirname "$0")" && pwd)"
    prefix="$(cd "$script_dir/.." && pwd)"
    exec ${nodejs_22}/bin/node \
      "$prefix/lib/node_modules/${pname}/dist/entry.js" "$@"
    EOF
    chmod +x $out/bin/moltbot

    runHook postInstall
  '';
}
