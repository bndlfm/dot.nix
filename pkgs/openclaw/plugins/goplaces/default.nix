{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goplaces";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "goplaces";
    rev = "main";
    hash = "sha256-C14EvcdAGwRJmQPlhVKHL0Ugrk79RvHJRMjTo/JeYKE=";
  };

  vendorHash = "sha256-OFTjLtKwYSy4tM+D12mqI28M73YJdG4DyqPkXS7ZKUg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Google Places CLI";
    homepage = "https://github.com/steipete/goplaces";
    license = licenses.mit;
    mainProgram = "goplaces";
  };
}
