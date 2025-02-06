{ pkgs ? import <nixpkgs> {} }:
let
  python-gnupg = pkgs.python3Packages.buildPythonPackage rec {
    pname = "python-gnupg";
    version = "0.5.4";

    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-8v21+ylhXHfCdD4cs9kxQ1Om6HsQw30jjZGuHG/q4IY=";
    };

    # Inject a dummy setup.py so that the build phases complete.
    patchPhase = ''
      echo "from setuptools import setup; setup()" > setup.py
    '';

    # No tests; do nothing in the check phase.
    doCheck = false;

    meta = with pkgs.lib; {
      description = "Python module for gnupg integration";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };
in pkgs.python3Packages.buildPythonPackage rec {
  pname = "pass2bw";
  version = "0.2";

  # Fetch the source from GitHub.
  src = pkgs.fetchFromGitHub {
    owner = "quulah";
    repo = "pass2bitwarden";
    rev = "487c90ca00661fd332d362b3a456c00fdd430370";
    hash = "sha256-sKapqUt8MoFVy+dqA/x18N7JMdO/HJ/1IaJcO/nBofM=";
  };

  # Dependencies: Python 3 and our patched python-gnupg.
  nativeBuildInputs = [
    pkgs.python3
    python-gnupg
  ];

  # Since the script is pure Python and doesn’t need building,
  # simply install it as an executable.
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
