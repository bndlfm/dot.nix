{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:
let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      httpx
      python-dotenv
      rich
      mcp
    ]
  );
in
stdenvNoCC.mkDerivation rec {
  pname = "jellyseerr-mcp";
  version = "unstable-2026-02-14";

  src = fetchFromGitHub {
    owner = "aserper";
    repo = "jellyseerr-mcp";
    rev = "787dd16e5dfed9d041e4aa5791666590fba32604";
    hash = "sha256-4UX0KhcYkktskCiHt5rSzaJDll8bEDXu2Rp9NQmxm70=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/jellyseerr-mcp"
    cp -r jellyseerr_mcp "$out/share/jellyseerr-mcp/"

    mkdir -p "$out/bin"
    makeWrapper ${pythonEnv}/bin/python "$out/bin/jellyseerr-mcp" \
      --set PYTHONPATH "$out/share/jellyseerr-mcp" \
      --add-flags "-m jellyseerr_mcp"

    runHook postInstall
  '';

  meta = with lib; {
    description = "MCP server for Jellyseerr";
    homepage = "https://github.com/aserper/jellyseerr-mcp";
    license = licenses.mit;
    mainProgram = "jellyseerr-mcp";
    platforms = platforms.linux;
  };
}
