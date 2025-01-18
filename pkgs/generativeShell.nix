{ pkgs ? import <nixpkgs> {} }:

pkgs.buildGoModule rec {
  pname = "gsh";
  version = "v0.7.0";

  src = pkgs.fetchFromGitHub {
    owner = "atinylittleshell";
    repo = "gsh";
    rev = "${version}";
    hash = "sha256-UwhudVDce0ybBtDHF9kXvnx7dfdGHK/0Aolc6N3Pp1c=";
  };

  vendorHash = "sha256-zT72HC201OSYAnQRhUieChaPiBCS9s/NVqVBgIQ4BMo=";

  meta = with pkgs.lib; {
    description = "(g)enerative (sh)ell, a shell with generative AI features.";
    homepage = "https://github.com/atinylittleshell/gsh";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bndlfm ];
  };
}
