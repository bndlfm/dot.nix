{ lib
, appimageTools
, fetchurl
, fetchzip
, android-tools
, makeWrapper
}:

let
  pname = "vr-cyberdeck";
  version = "1.7.6";

  src = fetchurl {
    url = "https://github.com/DeliciousMeatPop/VRCD/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    hash = "sha256-qYT2cU9LVmVFqwxDCBT/S3UpCGF1W+mqLz7g4/gLkhE=";
  };

  rcloneVersion = "1.72.1";

  rclonePinned = fetchzip {
    pname = "rclone";
    version = rcloneVersion;
    url = "https://github.com/rclone/rclone/releases/download/v${rcloneVersion}/rclone-v${rcloneVersion}-linux-amd64.zip";
    hash = "sha256-DhPrQpLBjAylAkfGyOFRQvrZkVhovKOcTNT1+Z3nkzo=";
    stripRoot = true;
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraPkgs = pkgs: with pkgs; [
    android-tools
    rclonePinned
  ];

  # CyberDeck resolves rclone and adb below Electron's userData directory,
  # rather than through PATH. Seed those paths from immutable Nix binaries.
  profile = ''
    vrcdBinDir="''${XDG_CONFIG_HOME:-$HOME/.config}/vr-cyberdeck/bin"
    mkdir -p "$vrcdBinDir"
    cp -f ${rclonePinned}/rclone "$vrcdBinDir/rclone"
    cp -f ${android-tools}/bin/adb "$vrcdBinDir/adb"
    chmod 755 "$vrcdBinDir/rclone" "$vrcdBinDir/adb"
  '';

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/${pname}.desktop \
      $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} --no-sandbox --disable-gpu %U'
    wrapProgram $out/bin/${pname} \
      --add-flags "--disable-gpu"
  '';

  meta = {
    description = "Cyberpunk desktop sideloader for Meta Quest VR headsets";
    homepage = "https://github.com/DeliciousMeatPop/VRCD";
    downloadPage = "https://github.com/DeliciousMeatPop/VRCD/releases";
    license = lib.licenses.gpl3Only;
    mainProgram = pname;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
