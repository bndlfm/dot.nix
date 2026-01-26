{ lib
, stdenv
, fetchPnpmDeps
, fetchFromGitHub
, nodejs_22
, pnpm
, pnpmConfigHook
, python3
, pkg-config
, makeWrapper
, vips
, sqlite
, openssl
, src
, homebrewRev ? "master"
, homebrewHash ? "sha256-hAofZ16BvMdymQGhUUqIvaI5fgHE6smkhSl7mYlPltY="
}:

let
  homebrew = fetchFromGitHub {
    owner = "Homebrew";
    repo = "brew";
    rev = homebrewRev;
    hash = homebrewHash;
  };
in
stdenv.mkDerivation rec {
  pname = "clawdbot";
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
    makeWrapper
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
    makeWrapper ${nodejs_22}/bin/node $out/bin/clawdbot \
      --add-flags $out/lib/node_modules/${pname}/dist/entry.js \
      --prefix PATH : ${homebrew}/bin \
      --set-default HOMEBREW_PREFIX ${homebrew} \
      --set-default HOMEBREW_REPOSITORY ${homebrew} \
      --set-default HOMEBREW_CELLAR ${homebrew}/Cellar

    runHook postInstall
  '';
}
