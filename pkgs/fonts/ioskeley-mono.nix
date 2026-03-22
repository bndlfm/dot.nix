{
  lib,
  stdenv,
  fetchzip,
}:
let
  version = "2025.10.09-6";
  src = fetchzip {
    url = "https://github.com/ahatem/IoskeleyMono/releases/download/${version}/IoskeleyMono-TTF-Hinted.zip";
    sha256 = "sha256-XX5LYt3hf/EIWiyhrGYZHur4cOZIYHQSdaqLHaFDkyM=";
  };
in
stdenv.mkDerivation {
  pname = "ioskeley-mono";
  inherit version src;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    find $src -name "*.ttf" -exec cp -v {} $out/share/fonts/truetype \;
  '';

  meta = with lib; {
    description = "Iosevka configuration to mimic the look and feel of Berkeley Mono";
    homepage = "https://github.com/ahatem/IoskeleyMono";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
