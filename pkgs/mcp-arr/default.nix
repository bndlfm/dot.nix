{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "mcp-arr";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "aplaceforallmystuff";
    repo = "mcp-arr";
    rev = "main";
    hash = "sha256-/2tvonQzkr9KiKM7d8ZDn6E5+E8Wg7vyk7MToLurtjw=";
  };

  npmDepsHash = "sha256-szJ6acsqEop5vhb0C6Jk/xwW9ugVZboEp+MOTk/fTBs=";
  npmBuildScript = "build";
  npmInstallFlags = [ "--include=dev" ];
  npmPruneFlags = [ "--include=dev" ];

  meta = with lib; {
    description = "MCP server for *arr media management suite";
    homepage = "https://github.com/aplaceforallmystuff/mcp-arr";
    license = licenses.mit;
    mainProgram = "mcp-arr";
  };
}
