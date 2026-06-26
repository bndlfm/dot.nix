{
  lib,
  pkgs,
  python3Packages,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  stdenv,
  ast-grep,
  onnxruntime,
  zlib,
  llvmPackages,
  autoPatchelfHook,
  uv,
}:

let
  litellm' = python3Packages.litellm.overridePythonAttrs (old: rec {
    version = "1.82.3";
    src = python3Packages.fetchPypi {
      pname = "litellm";
      inherit version;
      hash = "sha256-chW5XnzDilK1rneNZ+iCneyGWUyLBdhDEpTpXH1Zk3w=";
    };
    patches = [ ];
    postPatch = "";
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ python3Packages.poetry-core ];
    doCheck = false;
  });

  # headroom expects ast-grep-cli to be installed to satisfy its python metadata requirements.
  # Since we provide the actual ast-grep binary via nixpkgs, this shim satisfies the dependency.
  ast-grep-cli' = python3Packages.buildPythonPackage rec {
    pname = "ast-grep-cli";
    version = "0.35.0";
    format = "setuptools";
    src = pkgs.writeTextDir "setup.py" ''
      from setuptools import setup
      setup(
          name="${pname}",
          version="${version}",
          packages=[],
      )
    '';
    sourceRoot = ".";
    unpackPhase = "cp -r $src/* .";
  };
in
python3Packages.buildPythonApplication rec {
  pname = "headroom";
  version = "0.23.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "chopratejas";
    repo = "headroom";
    rev = "v${version}";
    hash = "sha256-4pQUSi8dU85tm5WY8Z/ZEN8O/ccGDDVIC3SnNBvUZTY=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    python3Packages.setuptools
    pkg-config
    llvmPackages.libclang.lib
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
    onnxruntime
    zlib
  ] ++ lib.optional stdenv.hostPlatform.isDarwin [
    python3Packages.apple-sdk_11
  ];

  propagatedBuildInputs = with python3Packages; [
    tiktoken
    pydantic
    litellm'
    ast-grep-cli'
    click
    rich
    opentelemetry-api
    tomli
    
    # Proxy / ML dependencies
    fastapi
    uvicorn
    httpx
    h2
    openai
    magika
    zstandard
    websockets
    onnxruntime
    watchdog
    sqlite-vec
  ];

  # headroom calls ast-grep CLI and Serena MCP wants uv.
  # We also need to ensure the python path is correct for internal imports.
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ast-grep uv ]}"
    "--set LD_LIBRARY_PATH ${lib.makeLibraryPath [ onnxruntime zlib ]}"
    "--prefix PYTHONPATH : $out/${python3Packages.python.sitePackages}:${python3Packages.makePythonPath propagatedBuildInputs}"
  ];

  # maturin build logic
  # We force ORT_PREFER_DYNAMIC_LINK=1 to avoid static link search for .a files.
  preBuild = ''
    export HOME=$(mktemp -d)
    export ORT_LIB_LOCATION=${onnxruntime}/lib
    export ORT_PREFER_DYNAMIC_LINK=1
    export LIBCLANG_PATH=${llvmPackages.libclang.lib}/lib
    export LD_LIBRARY_PATH=${onnxruntime}/lib:${zlib}/lib:$LD_LIBRARY_PATH
    export LIBRARY_PATH=${onnxruntime}/lib:${zlib}/lib:$LIBRARY_PATH
  '';

  meta = with lib; {
    description = "Compress tool outputs, logs, files ... 60-95% fewer tokens";
    homepage = "https://github.com/chopratejas/headroom";
    license = licenses.asl20;
    mainProgram = "headroom";
  };
}
