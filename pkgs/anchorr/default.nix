{
  bash,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "anchorr";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "nairdahh";
    repo = "Anchorr";
    rev = "v${version}";
    hash = "sha256-8xlablHtBtJuOgm/7hl4XWmyWYD+fE7L9igRECErDX4=";
  };

  npmDepsHash = "sha256-YXPLHloxRci8PIDB5g+myxP36JFhQ2M54hQC86+1mMY=";
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/anchorr"
    cp -r . "$out/lib/anchorr/"

    mkdir -p "$out/bin"
    cat > "$out/bin/anchorr" <<EOF
    #!${lib.getExe bash}
    set -euo pipefail
    cd "${placeholder "out"}/lib/anchorr"
    exec ${lib.getExe nodejs} app.js
    EOF
    chmod +x "$out/bin/anchorr"

    runHook postInstall
  '';

  meta = {
    description = "Discord bot for Jellyseerr requests and Jellyfin notifications";
    homepage = "https://github.com/nairdahh/Anchorr";
    license = lib.licenses.mit;
    mainProgram = "anchorr";
    platforms = lib.platforms.linux;
  };
}
