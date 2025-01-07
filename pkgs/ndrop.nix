{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "ndrop";
  version = "34aa284";

  src = pkgs.fetchFromGitHub {
    owner = "Schweber"; # Assuming this is the correct owner from the README
    repo = "ndrop";
    rev = "main"; # Or a specific tag/commit
    sha256 = ""; # Replace with actual sha256
  };

  buildInputs = [ pkgs.bash pkgs.jq ];

  installPhase = ''
    mkdir -p $out/bin
    cp ndrop $out/bin
    chmod +x $out/bin/ndrop
  '';

  meta = with pkgs.lib; {
    description = "Bash script to emulate tdrop in niri";
    homepage = "https://github.com/Schweber/ndrop"; # Adjust if the owner is different
    license = licenses.agpl3; # Check the repository for the actual license
    platforms = platforms.linux;
    maintainers = with maintainers; [ ]; # Add your nixos.org username if you maintain it
  };
}
