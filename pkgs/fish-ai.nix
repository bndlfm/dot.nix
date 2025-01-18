{ stdenv, lib, fetchFromGitHub, python3Packages, fish, makeWrapper }:

python3Packages.buildPythonApplication rec {
  pname = "fish-ai";
  version = "1.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Realiserad";
    repo = "fish-ai";
    rev = "v${version}";
    hash = "";
  };

  nativeBuildInputs = [
    makeWrapper
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
