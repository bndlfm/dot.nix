{
  lib,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "volantes-hyprcursor";
  version = "0.1";
  src = ./.;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/volantes-light-hyprcursor
    cp -R $src/light/. $out/share/icons/volantes-light-hyprcursor/

    mkdir -p $out/share/icons/volantes-dark-hyprcursor
    cp -R $src/dark/. $out/share/icons/volantes-dark-hyprcursor/

    runHook postInstall
  '';

  meta = with lib; {
    description = "volantes cursors in hyprcursor format";
    downloadPage = "https://github.com/bndlfm/volantes-hyprcursor";
    homepage = "https://www.deviantart.com/aystic/gallery";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ bndlfm ];
  };
})
