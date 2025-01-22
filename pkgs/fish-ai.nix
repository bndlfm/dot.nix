{ stdenv, lib, fetchFromGitHub, python3Packages, fish, makeWrapper }: let
  pyPkgs = python3Packages;

  hugchat = pyPkgs.buildPythonPackage rec {
    pname = "hugchat";
    version = "0.4.17";

    src = pyPkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-NZV3gpnkURwGmya0OZUGh8j40vWCZJm0BYJ3Vyxn7Ag=";
    };

    propagatedBuildInputs = with pyPkgs; [
      requests
      websocket-client
    ];
  };

  pydantic' = pyPkgs.buildPythonPackage rec {
    pname = "pydantic";
    version = "2.8.2";
    format = "pyproject";

    src = pyPkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-b2LBPQZ7B1WtHCGjS90GwMEmJaIrD8CcaxSYFmBPfCo=";
    };

    nativeBuildInputs = with pyPkgs; [      annotated-types
      poetry-core
      (pkgs.python3Packages.pydantic-core.overrideAttrs (oldAttrs: rec {
        version = "2.20.1";
        src = pkgs.fetchPypi {
          pname = "pydantic_core";
          version = version;
          sha256 = "sha256-JsppXu7l+fGu6yEf/BLxC8tvceKYmYj9ph2r1l24eNQ=";
        };
      }))
      typing-extensions
      hatchling
      hatch-fancy-pypi-readme
    ];

    SETUPTOOLS_SCM_PRETEND_VERSION = version;

    doCheck = false;
  };

  mistralai = let
    jsonpath-python = pyPkgs.buildPythonPackage rec {
        pname = "jsonpath-python";
        version = "1.0.6";

        src = pyPkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-3Vvkpy2KKZXD9YPPgr880alUTP2r8tIllbZ6/wc0lmY=";
        };
      };
    in
      pyPkgs.buildPythonPackage rec {
        pname = "mistralai";
        version = "1.0.2";
        format = "pyproject";

        src = pyPkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-RvtEB9GkFhsj4bLExzVHhDP7ekGrsF+s0jJy+wXRcbU=";
        };

        nativeBuildInputs = with pyPkgs; [
          poetry-core
        ];

        propagatedBuildInputs = with pyPkgs; [
          eval-type-backport
          httpx
          jsonpath-python
          pydantic'
          python-dateutil
          typing-extensions
          typing-inspect
          filelock
        ];

        SETUPTOOLS_SCM_PRETEND_VERSION = version;

        doCheck = false;
      };


in


  python3Packages.buildPythonApplication rec {
    pname = "fish-ai";
    version = "1.0.0";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "realiserad";
      repo = "fish-ai";
      rev = "v${version}";
      hash = "sha256-OnKkANNR51G34edj2HbohduaFARk6ud15N3+ULYs7s4=";
    };

    nativeBuildInputs = [
      makeWrapper
      pyPkgs.setuptools
      pyPkgs.wheel
    ];

    propagatedBuildInputs = with python3Packages; [
      openai
      simple-term-menu
      iterfzf
      hugchat
      mistralai
      binaryornot
      anthropic
      cohere
    ];

    postPatch = ''
      # Patch fish scripts to use the correct paths
      for file in $(find functions conf.d -name "*.fish"); do
        sed -i "s|~/.fish-ai/bin/|${placeholder "out"}/bin/|g" "$file"
      done
    '';

    postInstall = ''
      # Install fish plugin files
      mkdir -p $out/share/fish/vendor_conf.d
      mkdir -p $out/share/fish/vendor_functions.d
      cp -r conf.d/* $out/share/fish/vendor_conf.d/
      cp -r functions/* $out/share/fish/vendor_functions.d/

      # Wrap the python executables to set the correct PYTHONPATH
      wrapProgram $out/bin/fix --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3Packages.python.sitePackages}"
      wrapProgram $out/bin/codify --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3Packages.python.sitePackages}"
      wrapProgram $out/bin/explain --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3Packages.python.sitePackages}"
      wrapProgram $out/bin/autocomplete --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3Packages.python.sitePackages}"
      wrapProgram $out/bin/switch_context --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3Packages.python.sitePackages}"
      wrapProgram $out/bin/lookup_setting --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3Packages.python.sitePackages}"
    '';

    meta = with lib; {
      description = "Provides core functionality for fish-ai, an AI plugin for the fish shell.";
      homepage = "https://github.com/Realiserad/fish-ai";
      license = licenses.mit;
      maintainers = with maintainers; [ ];
      platforms = platforms.all;
    };
}
