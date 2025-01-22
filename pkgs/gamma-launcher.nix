{ pkgs ? import <nixpkgs> {} }:

pkgs.buildPythonPackage rec {
  pname = "gamma-launcher";
  version = "2.3";

  src = ./.;

  propagatedBuildInputs = with pkgs.python3Packages; [
    beautifulsoup4
    cloudscraper
    GitPython
    platformdirs
    py7zr
    unrar
    requests
    tenacity
    tqdm
    setuptools
  ];

  # Run tests if any, currently there are no explicit tests defined in the repo.
  # checkPhase = ''
  #   ${pkgs.python3Packages.pytest}/bin/pytest
  # '';

  pythonImportsCheck = [ "launcher" ];

  meta = with pkgs.lib; {
    description = "G.A.M.M.A. Launcher module";
    homepage = "https://github.com/Mord3rca/gamma-launcher";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bndlfm ];
  };
}
