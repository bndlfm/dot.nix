{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "ndrop";
  version = "34aa284";

  src = pkgs.fetchFromGitHub {
    owner = "Schweber"; # Assuming this is the correct owner from the README
    repo = "ndrop";
    rev = "main"; # Or a specific tag/commit
    sha256 = "sha256-K3r+qGwaRKuolLQF5qB5ujyIvEZ8B5z0FM/O+lY1zpw"; # Replace with actual sha256
  };

  buildInputs = [ pkgs.bash pkgs.jq ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ndrop $out/bin
    chmod +x $out/bin/ndrop
  '';

  meta = with pkgs.lib; {
    description = "Bash script to emulate tdrop in niri";
    homepage = "https://github.com/Schweber/ndrop";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
