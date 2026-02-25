{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeBinaryWrapper,
  nodejs_22,
  pnpm_10,
  pnpmConfigHook,
  git,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "summarize";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "summarize";
    rev = "main";
    hash = "sha256-3l9rt7qoUkihsCopDSHxC9Oq5XwkFI65SzehHDOg46c=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 1;
    pnpmInstallFlags = [ "--no-frozen-lockfile" ];
    hash = "sha256-PA/FEHyUPddWi/9wryyHWNMruZHauK0Fx2o3l8kFsZI=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs_22
    pnpmConfigHook
    pnpm_10
    git
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/summarize}
    cp -r dist node_modules package.json $out/lib/summarize
    makeWrapper ${lib.getExe nodejs_22} $out/bin/summarize \
      --inherit-argv0 \
      --add-flags $out/lib/summarize/dist/cli.js
    ln -s $out/bin/summarize $out/bin/summarizer
    runHook postInstall
  '';

  dontCheckForBrokenSymlinks = true;

  meta = with lib; {
    description = "Link → clean text → summary";
    homepage = "https://github.com/steipete/summarize";
    license = licenses.mit;
    mainProgram = "summarize";
  };
})
