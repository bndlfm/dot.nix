{
  lib,
  stdenv,
  fetchzip,
}:
let
  #version = "v2.0.0-beta.1"; # For some reason v2.0.0-beta.1 installs condensed font.
  version = "2026.03.19-7";
  src = fetchzip {
    url = "https://github.com/ahatem/IoskeleyMono/releases/download/2026.03.19-7/IoskeleyMono-NerdFont.zip";
    sha256 = "sha256-TAneNRImlRNsvTr6xDCG+VKFycttbTxkP6hfh9Kr+X4=";
    stripRoot = false;
  };
  #  ioskelCon = fetchzip {
  #    url = "https://github.com/ahatem/IoskeleyMono/releases/download/${version}/IoskeleyMono-NerdFont-Condensed.zip";
  #    sha256 = "sha256-TAneNRImlRNsvTr6xDCG+VKFycttbTxkP6hfh9Kr+X4=";
  #    stripRoot = false;
  #  };
  #  ioskelSemiCon = fetchzip {
  #    url = "https://github.com/ahatem/IoskeleyMono/releases/download/${version}/IoskeleyMono-NerdFont-SemiCondensed.zip";
  #    sha256 = "sha256-W1ykPzdsoXfRBJ5YuxrjOc/J7uzwLQRjZTc9G2cj06Y=";
  #    stripRoot = false;
  #  };
in
stdenv.mkDerivation {
  pname = "ioskeley-mono-NF";
  inherit
    version
    src
    #    ioskelCon
    #    ioskelSemiCon
    ;

  dontBuild = true;

  installPhase = ''
        mkdir -p $out/share/fonts/truetype
        find $src -name "*.ttf" -exec cp -v {} $out/share/fonts/truetype \;
    #    find $ioskelCon -name "*.ttf" -exec cp -v {} $out/share/fonts/truetype \;
    #    find $ioskelSemiCon -name "*.ttf" -exec cp -v {} $out/share/fonts/truetype \;
  '';

  meta = with lib; {
    description = "Iosevka configuration to mimic the look and feel of Berkeley Mono";
    homepage = "https://github.com/ahatem/IoskeleyMono";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
