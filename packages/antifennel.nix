{ stdenv, fetchgit, luajit, lua5_4, lib }:

stdenv.mkDerivation rec {
  pname = "antifennel";
  version = "0.2.0";

  src = fetchgit {
    url = "https://git.sr.ht/~technomancy/antifennel";
    rev = version;
    sha256 = "1hd9h17q31b3gg88c657zq4han4air2ag55rrakbmcpy6n8acsqc";
  };

  # Choose the Lua implementation: luajit or lua5_4
  lua = luajit; # Change to lua5_4 if preferred

  buildInputs = [ lua ];

  # Determine the Lua interpreter path
  luaInterpreter = "${lua}/bin/luajit";

  # Set the LUA variable for Make and the installation PREFIX
  makeFlags = [
    "LUA=${luaInterpreter}"
  ];

  # Since there's no configure script, skip the configure phase
  configurePhase = "true";

  # The default build and install phases will use make with makeFlags
  # No need to override them unless additional customization is required

  meta = with lib; {
    homepage = "https://git.sr.ht/~technomancy/antifennel";
    longDescription = "A tool to turn Lua code into Fennel code (the opposite of what the Fennel compiler does)";
    description = "Turn Lua code into Fennel code";
    license = licenses.mit; # Expat license
    maintainers = with lib.maintainers; [ bndlfm ]; # Add yourself if you wish
  };
}
