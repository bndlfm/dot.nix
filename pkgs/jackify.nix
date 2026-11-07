{
  appimageTools,
  fetchurl,
  lib,
  python3,
}:

let
  pname = "jackify";
  version = "0.8.1.3";

  src = fetchurl {
    url = "https://github.com/Omni-guides/Jackify/releases/download/v${version}/Jackify.AppImage";
    hash = "sha256-Z3T4Gu3WxnyMOO7kIF/BSXGJfNurmcZULTWCl4rzlTI=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Jackify's AppRun selects a system Python interpreter and uses it to run
  # the bundled Python application and jackify-engine bootstrap.
  extraPkgs = pkgs: [ python3 ];

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/com.jackify.app.desktop \
      $out/share/applications/com.jackify.app.desktop
    install -Dm644 ${appimageContents}/com.jackify.app.png \
      $out/share/icons/hicolor/512x512/apps/com.jackify.app.png
  '';

  meta = {
    description = "Linux-native Wabbajack modlist installer";
    homepage = "https://github.com/Omni-guides/Jackify";
    downloadPage = "https://github.com/Omni-guides/Jackify/releases";
    license = lib.licenses.gpl3Only;
    mainProgram = pname;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
