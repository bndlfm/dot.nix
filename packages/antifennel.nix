{ stdenv, fetchgit, luajit, lib }:

stdenv.mkDerivation rec {
  pname = "antifennel";
  version = "0.2.0";

  src = fetchgit {
    url = "https://git.sr.ht/~technomancy/antifennel";
    rev = version;
    sha256 = "sha256-DGumkDX+srqmyrmUp0SOilgFCf6nGIbQe2OFgU+AqcE="; # Replace with the actual sha256 hash
  };

  buildInputs = [ luajit ];

  # Only the install phase is needed
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 antifennel $out/bin/
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~technomancy/antifennel";
    longDescription = "A tool to turn Lua code into Fennel code (the opposite of what the Fennel compiler does)";
    description = "Turn Lua code into Fennel code";
    license = licenses.mit; # Expat license
    maintainers = with lib.maintainers; [ bndlfm ]; # Add yourself if you wish
  };
}
