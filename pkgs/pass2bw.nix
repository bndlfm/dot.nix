{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "pass2bw";
  version = "1.0";

  # Use the repository’s root as the source
  src = pkgs.fetchFromGitHub {
    owner = "quulah";
    repo = "pass2bitwarden";
    rev = "487c90ca00661fd332d362b3a456c00fdd430370";
    hash = "";
  };

  # Dependencies: Python 3 and python-gnupg
  buildInputs = [
    pkgs.python3
    pkgs.python3Packages.gnupg
  ];

  # No build phase is needed; simply install the script.
  installPhase = ''
    mkdir -p $out/bin
    cp pass2bw.py $out/bin/pass2bw
    chmod +x $out/bin/pass2bw
  '';

  meta = with pkgs.lib; {
    description = "A Python script to export data from pass to Bitwarden CSV format";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ "yourname@example.com" ];
  };
}
