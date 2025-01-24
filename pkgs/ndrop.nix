{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "ndrop";
  version = "34aa284";

  src = pkgs.fetchFromGitHub {
    owner = "Schweber"; # Assuming this is the correct owner from the README
    repo = "ndrop";
    rev = "main"; # Or a specific tag/commit
    sha256 = "sha256-/a0W2/c4RW/ZGJ5uhk4r0VRyLI1uOb5ef7Ww+T9Yh+0="; # Replace with actual sha256
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
