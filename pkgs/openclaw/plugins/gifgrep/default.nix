{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gifgrep";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gifgrep";
    rev = "main";
    hash = "sha256-uhmcodbc4cvUKvKbcJHKz3tlzKiWcMrp8yptXkOf/Zs=";
  };

  vendorHash = "sha256-IBChugE0+ELHgeTZ8kXi5FH7CHB1chvt56/3Lhm1TiI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Search inside GIFs from the terminal";
    homepage = "https://github.com/steipete/gifgrep";
    license = licenses.mit;
    mainProgram = "gifgrep";
  };
}
