{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchPnpmDeps
, makeBinaryWrapper
, nodejs
, pnpm_9
, pnpmConfigHook
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bird";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "bird";
    rev = "main";
    hash = "sha256-cLT392XhO1ulyjDGMVpFJcGuS3YLXEfDuvHCGCzANeg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 1;
    pnpmInstallFlags = [ "--no-frozen-lockfile" ];
    postPatch = ''
      sed -i '/"pnpm": {/,/},/d' package.json
      sed -i '/^patchedDependencies:/,/^importers:/ {/importers:/!d;}' pnpm-lock.yaml
      sed -i 's/(patch_hash=[^)]*)//g' pnpm-lock.yaml
      cat > pnpm-workspace.yaml <<'EOF'
      packages:
        - '.'
      EOF
    '';
    hash = "sha256-zYxGT/cIJCTNy0ROxMzYLGhgrvH3kDe5mlNfjvKNiZI=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  postPatch = ''
    sed -i '/"pnpm": {/,/},/d' package.json
    sed -i '/^patchedDependencies:/,/^importers:/ {/importers:/!d;}' pnpm-lock.yaml
    sed -i 's/(patch_hash=[^)]*)//g' pnpm-lock.yaml
    cat > pnpm-workspace.yaml <<'EOF'
    packages:
      - '.'
    EOF
  '';

  buildPhase = ''
    runHook preBuild
    pnpm run build:dist
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/bird}
    cp -r dist node_modules package.json $out/lib/bird
    makeWrapper ${lib.getExe nodejs} $out/bin/bird \
      --inherit-argv0 \
      --add-flags $out/lib/bird/dist/cli.js
    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI tool for tweeting and replying via Twitter/X GraphQL API";
    homepage = "https://github.com/steipete/bird";
    license = licenses.mit;
    mainProgram = "bird";
  };
})
