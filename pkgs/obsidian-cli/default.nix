{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "obsidian-cli";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "Yakitrak";
    repo = "obsidian-cli";
    rev = "main";
    hash = "sha256-i20xt5e867KJ+9uuktc2vEemvkUft9dPdJwYTjBl9Gk=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Interact with Obsidian vaults from the terminal";
    homepage = "https://github.com/Yakitrak/obsidian-cli";
    license = licenses.mit;
    mainProgram = "obsidian-cli";
  };
}
