{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "songsee";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "songsee";
    rev = "main";
    hash = "sha256-URLRf62DjdktK9P13boSIx7h4Xr6U2qXCh1rEHsRyFs=";
  };

  vendorHash = "sha256-JTxmR3+Bw8KGU+tjgwjL97ScHYwbMmNIMLs9bvBgtWQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Now playing CLI";
    homepage = "https://github.com/steipete/songsee";
    license = licenses.mit;
    mainProgram = "songsee";
  };
}
