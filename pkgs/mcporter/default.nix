{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchPnpmDeps
, makeBinaryWrapper
, nodejs_22
, pnpm_10
, pnpmConfigHook
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mcporter";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "mcporter";
    rev = "main";
    hash = "sha256-C4LnoDVhzfNQi/uEDluGP1cSTrIsH4XBuY5LDlH8Llg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 1;
    pnpmInstallFlags = [ "--no-frozen-lockfile" ];
    hash = "sha256-3DUaeQYX1mizEbGk8/elcuHFDVSBPBXWEzd3m+oZIUQ=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs_22
    pnpmConfigHook
    pnpm_10
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/mcporter}
    cp -r dist node_modules package.json $out/lib/mcporter
    makeWrapper ${lib.getExe nodejs_22} $out/bin/mcporter \
      --inherit-argv0 \
      --add-flags $out/lib/mcporter/dist/cli.js
    runHook postInstall
  '';

  meta = with lib; {
    description = "TypeScript runtime and CLI for connecting to configured Model Context Protocol servers";
    homepage = "https://github.com/steipete/mcporter";
    license = licenses.mit;
    mainProgram = "mcporter";
  };
})
