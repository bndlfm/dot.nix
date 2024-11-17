{
  lib,
  stdenvNoCC,
  fetchzip,
  writeScript,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-ge-rtsp-bin";
  version = "GE-Proton9-20-rtsp15";

  src = fetchzip {
    url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/${finalAttrs.version}-1/${finalAttrs.version}.tar.gz";
    hash = "sha256-dj5qO1AmV0KinrfgUcv+bWzLN9aaAAKf/GxX5o9b6Dc=";
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

  passthru.updateScript = writeScript "update-proton-ge-rtsp" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    repo="https://api.github.com/repos/SpookySkeletons/proton-ge-rtsp/releases"
    version="$(curl -sL "$repo" | jq 'map(select(.prerelease == false)) | .[0].tag_name' --raw-output)"
    update-source-version proton-ge-rtsp-bin "$version"
  '';

  meta = {
    description = ''
      Compatibility tool for Steam Play based on Wine and additional components, with RTSP support.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/SpookySkeletons/proton-ge-rtsp";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      # Add maintainers here
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
