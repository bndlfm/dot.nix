{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, alsa-lib
}:

buildGoModule rec {
  pname = "sag";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "sag";
    rev = "main";
    hash = "sha256-+zWixholntg8xUq7hO+tE6dGmqNID1ntVSc1BaeAeeY=";
  };

  vendorHash = "sha256-GjPiwo3apE3lyM2qbhkS0fTHNSSGhXkmqcssOMJu16c=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Search and analyze web pages";
    homepage = "https://github.com/steipete/sag";
    license = licenses.mit;
    mainProgram = "sag";
  };
}
