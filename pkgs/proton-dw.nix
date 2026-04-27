{
  lib,
  stdenvNoCC,
  fetchzip,
  writeScript,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dwproton-bin";
  version = "dwproton-10.0-26";

  src = fetchzip {
    url = "https://dawn.wine/dawn-winery/dwproton/releases/download/${finalAttrs.version}/${finalAttrs.version}-x86_64.tar.xz";
    hash = "sha256-TkwhJCHPS0PdDIEL5GrxJPR09uO9U2DR8l9KWFLIF2g=";
  };

  outputs = [
    "out"
    "steamcompattool"
  ];

  buildCommand = ''
    runHook preBuild
    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out
    ln -s $src $steamcompattool
    runHook postBuild
  '';

  passthru.updateScript = writeScript "update-dwproton" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    repo="https://dawn.wine/api/v1/repos/dawn-winery/dwproton/releases"
    version="$(curl -sL "$repo" | jq 'map(select(.prerelease == false)) | .[0].tag_name' --raw-output)"
    update-source-version dwproton-bin "$version"
  '';

  meta = {
    description = ''
      Compatibility tool for Steam Play based on Wine with Dawn Winery patches.
      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://dawn.wine/dawn-winery/dwproton";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
