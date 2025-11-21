{ pkgs ? import <nixpkgs> {} }:
let

  unrar' = pkgs.python3Packages.buildPythonPackage rec {
    pname = "unrar";
    version = "0.4";
    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-skRHpbkwJL5gDvglVmi6I6MPRRF2V3tpFVnqE1n30WQ=";
    };

    UNRAR_LIB_PATH = "${unrarLib}";

    build-system = with pkgs.python3Packages; [ setuptools-scm ];
    pyproject = true;

    doCheck = false;
  };

  unrarLib = pkgs.stdenv.mkDerivation {
    pname = "unrarLib";
    version = "7.1.3";
    src = pkgs.fetchurl {
      url = "https://www.rarlab.com/rar/unrarsrc-7.1.3.tar.gz";
      hash = "sha256-9+229V+1NhEgZ4HZ5W8mJe9EEaaxKXaIABlmF9nfkgo=";
    };

    buildPhase = ''
      make lib
    '';

    installPhase = ''
      mkdir -p $out/lib
      cp libunrar.so $out/lib/
    '';
  };

in

  pkgs.python3Packages.buildPythonPackage rec {
    pname = "gamma-launcher";
    version = "2.3";
    format = "pyproject";

    src = pkgs.fetchFromGitHub {
      owner = "Mord3rca";
      repo = "gamma-launcher";
      rev = "v${version}";
      hash = "sha256-wS4qA9+fEx5IneDLZfpQSo8Yiy86gUImtlJXkkt7n4c=";
    };

    nativeBuildInputs = with pkgs; [
      makeWrapper
      unrarLib
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
      beautifulsoup4
      cloudscraper
      gitpython
      platformdirs
      py7zr
      unrar'
      unrarLib
      requests
      tenacity
      tqdm
      setuptools
    ];

    #postInstall = ''
    #  wrapProgram $out/bin/gamma-launcher \
    #    --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [ unrarLib ]}
    #'';

    meta = with pkgs.lib; {
      description = "G.A.M.M.A. Launcher module";
      homepage = "https://github.com/Mord3rca/gamma-launcher";
      license = licenses.gpl3;
      maintainers = with maintainers; [ bndlfm ];
    };
  }
