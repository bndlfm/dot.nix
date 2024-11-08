{ stdenv, fetchgit, luajit, lib }:

stdenv.mkDerivation rec {
  pname = "antifennel";
  version = "0.2.0";

  src = fetchgit {
    url = "https://git.sr.ht/~technomancy/antifennel";
    rev = version;
    sha256 = "sha256-DGumkDX+srqmyrmUp0SOilgFCf6nGIbQe2OFgU+AqcE="; # Replace with the actual sha256 hash
  };
  
  buildInputs = [ luajit ]; # Choose the Lua implementation: luajit or lua5_4

  nativeBuildInputs = [ makeWrapper ];

  # Set the LUA variable for Make and the installation PREFIX
  makeFlags = [
    "LUA=${lua.interpreter}"
    "PREFIX=$(out)"
  ];

  # Define the build and install phases using GNU Make
  buildPhase = ''
    make ${makeFlags}
  '';

  installPhase = ''
    make install ${makeFlags}
  '';

  # Optional: If there are tests, you can define a checkPhase
  # checkPhase = ''
  #   make test ${makeFlags}
  # '';
  meta = with lib; {
    homepage = "https://git.sr.ht/~technomancy/antifennel";
    longDescription = "A tool to turn Lua code into Fennel code (the opposite of what the Fennel compiler does)";
    description = "Turn Lua code into Fennel code";
    license = licenses.mit; # Expat license
    maintainers = with lib.maintainers; [ bndlfm ]; # Add yourself if you wish
  };
}
