{ lib
, stdenv
, fetchFromGitHub
, curl
, lshw
, python3
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "ramalama";
  version = "0.1.0";  # You may want to adjust this version number

  src = fetchFromGitHub {
    owner = "containers";
    repo = "ramalama";
    rev = "9de085b";  # Replace with the actual commit hash or tag
    sha256 = "0000000000000000000000000000000000000000000000000000";  # Replace with the actual hash
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ curl lshw python3 ];

  installPhase = ''
    mkdir -p $out/bin
    cp ramalama $out/bin/ramalama
    chmod +x $out/bin/ramalama

    wrapProgram $out/bin/ramalama \
      --prefix PATH : ${lib.makeBinPath [ curl lshw ]} \
      --prefix PYTHONPATH : "${python3.pkgs.huggingface-hub}/lib/python${python3.pythonVersion}/site-packages"
  '';

  postFixup = ''
    substituteInPlace $out/bin/ramalama \
      --replace '#!/bin/bash' '#!${stdenv.shell}'
  '';

  meta = with lib; {
    description = "A tool for container-related tasks";
    homepage = "https://github.com/containers/ramalama";
    license = licenses.asl20;  # Adjust if the license is different
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];  # Add maintainers if known
  };
}

