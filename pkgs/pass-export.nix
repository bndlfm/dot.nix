{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "pass-export";
  version = "1.1.0";

  # Use the repository’s root as the source.
  src = pkgs.fetchFromGitHub {
    owner = "dvogt23";
    repo = "pass-export";
    rev = "80db1bdaeb360dbcbd740ac30806332679a4f618";
    hash = "sha256-VZklqITwX7YeJpC0+31BQRk8MOZDh8A9T0rkUTMHavQ=";
  };

  # No build is needed (the package is a shell script).
  buildPhase = "true";

  installPhase = ''
    # The Makefile is set up to install the script and its man page
    # when PREFIX is given. By setting PREFIX to $out the files will
    # be installed into $out/lib/password-store/extensions and
    # $out/share/man/man1.
    make install PREFIX=$out

    # Create a symlink in $out/bin for convenience. This allows users
    # to run the extension from their PATH.
    mkdir -p $out/bin
    ln -s ../lib/password-store/extensions/export.bash $out/bin/pass-export
  '';

  meta = with pkgs.lib; {
    description = "A Python script to export data from pass to Bitwarden CSV format";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ "yourname@example.com" ];
  };
}
