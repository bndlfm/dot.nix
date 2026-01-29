{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gogcli";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "main";
    hash = "sha256-DXRw5jf/5fC8rgwLIy5m9qkxy3zQNrUpVG5C0RV7zKM=";
  };

  vendorHash = "sha256-nig3GI7eM1XRtIoAh1qH+9PxPPGynl01dCZ2ppyhmzU=";

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
