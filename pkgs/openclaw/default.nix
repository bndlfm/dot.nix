{
  lib,
  stdenv,
  fetchPnpmDeps,
  fetchFromGitHub,
  bash,
  coreutils,
  nodejs_22,
  pnpm,
  pnpmConfigHook,
  python3,
  pkg-config,
  go,
  vips,
  sqlite,
  openssl,
  curl,
  uv,
  nodePackages,

  gemini-cli,
  codex,

  openclawRev ? "master",
  openclawHash ? "sha256-Hx88jTi4CozTznBWF8M9sw0ZBjfMgC4AbKaJY1JQXVQ=",
}:

let
  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "openclaw";
    rev = openclawRev;
    hash = openclawHash;
  };

in
stdenv.mkDerivation rec {
  pname = "openclaw";
  version = (lib.importJSON "${src}/package.json").version;

  inherit src;

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    lockfile = "${src}/pnpm-lock.yaml";
    hash = "sha256-BjJze+4IGmQLttN1z8/kEPii8qvKjLFN56AArvipluo=";
    fetcherVersion = 3;
  };

  nativeBuildInputs = [
    pnpmConfigHook
    python3
    pkg-config
    bash
  ];

  buildInputs = [
    vips
    sqlite
    openssl
  ];

  propagatedBuildInputs = [
    bash
    coreutils

    nodejs_22
    nodePackages.npm
    pnpm
    uv
    curl
    go

    codex
    gemini-cli
  ];

  env = {
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    PUPPETEER_SKIP_DOWNLOAD = "1";
  };

  buildPhase = ''
    runHook preBuild

    # Upstream A2UI bundling can fail in source-only fetches when vendor/app
    # dirs are not present. For gateway runtime, a placeholder bundle is
    # sufficient to keep CLI/server builds working.
    if ! pnpm canvas:a2ui:bundle; then
      echo "A2UI bundle step failed; writing placeholder bundle for Nix build."
      install -d src/canvas-host/a2ui
      printf '%s\n' 'export default {};' > src/canvas-host/a2ui/a2ui.bundle.js
      echo "nix-placeholder" > src/canvas-host/a2ui/.bundle.hash
    fi

    pnpm -s exec tsdown
    pnpm build:plugin-sdk:dts
    node --import tsx scripts/write-plugin-sdk-entry-dts.ts
    node --import tsx scripts/canvas-a2ui-copy.ts
    node --import tsx scripts/copy-hook-metadata.ts
    node --import tsx scripts/copy-export-html-templates.ts
    node --import tsx scripts/write-build-info.ts
    node --import tsx scripts/write-cli-compat.ts

    runHook postBuild
  '';

  installPhase = /* sh */ ''
    runHook preInstall

    install -d $out/lib/node_modules/${pname}

    cp -R \
      dist \
      assets \
      docs \
      extensions \
      patches \
      packages \
      skills \
      git-hooks \
      scripts \
      ui \
      node_modules \
      package.json \
      README.md \
      CHANGELOG.md \
      LICENSE \
      $out/lib/node_modules/${pname}/

    install -d $out/bin

    cat > $out/bin/openclaw <<'EOF'
    #!${stdenv.shell}
    set -euo pipefail

    # Set up npm prefix for global packages
    npm_prefix="''${XDG_DATA_HOME:-$HOME/.openclaw}/npm"
    mkdir -p "$npm_prefix"
    export NPM_CONFIG_PREFIX="$npm_prefix"

    # Add runtime dependencies and Homebrew to PATH
    export PATH="$npm_prefix/bin:$PATH"

    # Execute openclaw
    script_dir="$(cd "$(dirname "$0")" && pwd)"
    prefix="$(cd "$script_dir/.." && pwd)"

    exec ${nodejs_22}/bin/node \
      "$prefix/lib/node_modules/${pname}/dist/entry.js" "$@"
    EOF

    chmod +x $out/bin/openclaw

    runHook postInstall
  '';

  meta = with lib; {
    description = "Openclaw application";
    homepage = "https://github.com/openclaw/openclaw";
    mainProgram = "openclaw";
    license = licenses.free; # Adjust as needed
    maintainers = [ ];
    platforms = platforms.all;
  };
}
