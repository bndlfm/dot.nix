{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gogcli";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "main";
    hash = "sha256-BEUoxZwpnOeX7pKlU5/1OkHC4L7dAc7xjloOUNh0glA=";
  };

  vendorHash = "sha256-o92LiyLZ9GTU5ap6kehqqahdLZvroognA8LxCQ17ysg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "GOG CLI for downloading and managing games";
    homepage = "https://github.com/steipete/gogcli";
    license = licenses.mit;
    mainProgram = "gogcli";
  };
}
