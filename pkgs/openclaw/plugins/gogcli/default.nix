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
    hash = "sha256-k8dqJmeQlAP+Fqd+PrDHNys/jGdE0/6AAjN6WHNh5hw=";
  };

  vendorHash = "sha256-jMvPQfh4E3EKzFqFxaNMq1Ae/ZXQvUU3eAZ0DqM7+hc=";

  patches = [
    ./fix-types.patch
  ];

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
