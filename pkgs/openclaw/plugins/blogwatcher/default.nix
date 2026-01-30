{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "blogwatcher";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "Hyaxia";
    repo = "blogwatcher";
    rev = "main";
    hash = "sha256-/QglXHdFSpifIHc9HdYwJJ/pZskhzYdQrSdcCBeGgoo=";
  };

  subPackages = [ "cmd/blogwatcher" ];

  vendorHash = "sha256-TfcMKlr/mdElYLf2zw9iNLJgGVJzMVg97jJm015ClTQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Watch blogs and RSS feeds from the terminal";
    homepage = "https://github.com/Hyaxia/blogwatcher";
    license = licenses.mit;
    mainProgram = "blogwatcher";
  };
}
