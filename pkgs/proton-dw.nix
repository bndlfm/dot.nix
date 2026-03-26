{
  lib,
  stdenvNoCC,
  fetchzip,
  writeScript,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dwproton-bin";
  version = "dwproton-10.0-22";

  src = fetchzip {
    url = "https://dawn.wine/dawn-winery/dwproton/releases/download/${finalAttrs.version}/${finalAttrs.version}-x86_64.tar.xz";
    hash = "sha256-U/lLAF/WUxHInBgAt7YuDUM/eGGSv7mkjAACr15iW/0=";
  };

  outputs = [
    "out"
    "steamcompattool"
  ];

  buildCommand = ''
    runHook preBuild

    # Make it impossible to add to an environment. You should use the appropriate NixOS option.
    # Also leave some breadcrumbs in the file.
    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    ln -s $src $steamcompattool

    runHook postBuild
  '';

  passthru.updateScript = writeScript "update-dwproton" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    # Note: Requires adjustment to point to the correct API endpoint if not using standard GitHub releases
    echo "Update script needs manual adjustment for non-GitHub releases"
    exit 1
  '';

  meta = {
    description = ''
      Compatibility tool for Steam Play based on Wine and additional components.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://dawn.wine/dawn-winery/dwproton";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      bndlfm
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
