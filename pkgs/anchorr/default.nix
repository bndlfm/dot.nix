{
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

  npmDepsHash = lib.fakeHash;
  npmBuildScript = "none";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/anchorr"
    cp -r . "$out/lib/anchorr/"

    mkdir -p "$out/bin"
    cat > "$out/bin/anchorr" <<EOF
    #!${lib.getExe nodejs}
    import { spawn } from "node:child_process";
    import process from "node:process";

    const appDir = "${placeholder "out"}/lib/anchorr";
    const child = spawn(process.execPath, ["app.js"], {
      cwd: appDir,
      stdio: "inherit",
      env: process.env,
    });

    child.on("exit", (code, signal) => {
      if (signal) process.kill(process.pid, signal);
      process.exit(code ?? 0);
    });
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
