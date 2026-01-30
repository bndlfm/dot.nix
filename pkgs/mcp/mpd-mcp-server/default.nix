{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mpd-mcp-server";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "gamoutatsumi";
    repo = "mpd-mcp-server";
    rev = "main";
    hash = "sha256-IxqNpjBy8n66PMc3FazpxsuFyobTSZ9LRATkDscIywU=";
  };

  vendorHash = "sha256-yox4oz9VQlE8dolPmu4Sl91OjbPbv9ymSiBZIEOjD4I=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "MCP server that exposes MPD operations";
    homepage = "https://github.com/gamoutatsumi/mpd-mcp-server";
    license = licenses.mit;
    mainProgram = "mpd-mcp-server";
  };
}
