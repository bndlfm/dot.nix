{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "mcp-arr";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "bndlfm";
    repo = "mcp-arr";
    rev = "a4c23b24ed5ae8809248e1b510ed959304170bac";
    hash = "sha256-+qcDFT1SOBS+WOynuRt0G9Z7/TzjkSg6nJJLmEeBZgM=";
  };

  npmDepsHash = "sha256-8uYGyMse559vTN+tD+ny5sqXu/fVecO3yH96rjw97kY=";
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
