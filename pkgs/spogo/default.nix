{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "spogo";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "spogo";
    rev = "main";
    hash = "sha256-zfrokd0onbddr5S9VOUxvT5CUeDbQSICLSJWABqIFa4=";
  };

  vendorHash = "sha256-ROlOn/55as4EBKqQr/wP5cVo1EBS4LnbHrrxCKF6VjU=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Spotify Go CLI";
    homepage = "https://github.com/steipete/spogo";
    license = licenses.mit;
    mainProgram = "spogo";
  };
}
