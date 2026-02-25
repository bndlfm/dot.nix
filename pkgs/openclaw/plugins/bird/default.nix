{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeBinaryWrapper,
  nodejs,
  pnpm_9,
  pnpmConfigHook,
  jq,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bird";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "bird";
    rev = "main";
    hash = "sha256-3l9rt7qoUkihsCopDSHxC9Oq5XwkFI65SzehHDOg46c=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 1;
    pnpmInstallFlags = [ "--no-frozen-lockfile" ];
    postPatch = ''
      ${jq}/bin/jq 'del(.pnpm, .packageManager)' package.json > package.json.tmp && mv package.json.tmp package.json
      sed -i '/^overrides:/,/^importers:/ {/importers:/!d;}' pnpm-lock.yaml
      sed -i '/^patchedDependencies:/,/^importers:/ {/importers:/!d;}' pnpm-lock.yaml
      sed -i 's/(patch_hash=[^)]*)//g' pnpm-lock.yaml
      cat > pnpm-workspace.yaml <<'EOF'
      packages:
        - '.'
        - 'packages/*'
      EOF
    '';
    hash = "sha256-NCKSxN1dbokeZh/gCt7qHV+EyVDqG1n4HWuWSordK5I=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpmConfigHook
    pnpm_9
    jq
  ];

  postPatch = ''
    jq 'del(.pnpm, .packageManager)' package.json > package.json.tmp && mv package.json.tmp package.json
    sed -i '/^overrides:/,/^importers:/ {/importers:/!d;}' pnpm-lock.yaml
    sed -i '/^patchedDependencies:/,/^importers:/ {/importers:/!d;}' pnpm-lock.yaml
    sed -i 's/(patch_hash=[^)]*)//g' pnpm-lock.yaml
    cat > pnpm-workspace.yaml <<'EOF'
    packages:
      - '.'
      - 'packages/*'
    EOF
  '';

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/bird}
    cp -r dist packages node_modules package.json $out/lib/bird
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
