{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "camsnap";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "camsnap";
    rev = "main";
    hash = "sha256-HimSYUJ4dZ8Bcq2B78cFgFRNktQqo++kJx8X4sIBmeM=";
  };

  vendorHash = "sha256-wDwVFjphqR9jspQOA12HvKFwpl7+iok4p71ka8vhiQ8=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Camera capture CLI";
    homepage = "https://github.com/steipete/camsnap";
    license = licenses.mit;
    mainProgram = "camsnap";
  };
}
