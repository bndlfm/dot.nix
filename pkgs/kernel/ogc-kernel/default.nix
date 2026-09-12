{
  fetchFromGitHub,
  lib,
  linuxPackages_7_1,
}:

assert lib.assertMsg (linuxPackages_7_1.kernel.version == "7.1.8") ''
  OGC kernel v7.1.8-ogc1 expects nixpkgs linuxPackages_7_1 at 7.1.8,
  but found ${linuxPackages_7_1.kernel.version}. Update the pinned OGC source
  and package definition deliberately instead of inheriting version drift.
'';

linuxPackages_7_1.kernel.override {
  argsOverride = {
    src = fetchFromGitHub {
      owner = "OpenGamingCollective";
      repo = "linux";
      rev = "86a4e13f16fb876282a12cc7680b3eb73d990e6b"; # tag v7.1.8-ogc1
      hash = "sha256-QAFl1QKkEJJ2j79LFXhOmnVRgN9LlGiDCFzYDx5f7tE=";
    };
    version = "7.1.8-ogc1";
    modDirVersion = "7.1.8";
  };

  structuredExtraConfig = with lib.kernel; {
    HID_ASUS_ALLY = module;
  };
}
