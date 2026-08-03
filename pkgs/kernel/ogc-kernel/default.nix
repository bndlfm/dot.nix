{
  fetchFromGitHub,
  lib,
  linuxPackages_7_1,
}:

assert lib.assertMsg (linuxPackages_7_1.kernel.version == "7.1.5") ''
  OGC kernel v7.1.5-ogc2 expects nixpkgs linuxPackages_7_1 at 7.1.5,
  but found ${linuxPackages_7_1.kernel.version}. Update the pinned OGC source
  and package definition deliberately instead of inheriting version drift.
'';

linuxPackages_7_1.kernel.override {
  argsOverride = {
    src = fetchFromGitHub {
      owner = "OpenGamingCollective";
      repo = "linux";
      rev = "e5f0343e484d49258c70e9c128570cb93195ce21"; # tag v7.1.5-ogc2
      hash = "sha256-T3BPgb5utVa+F5ZCUUDEV+ae0AnB0Pmz8JMu+Jv5Qk8=";
    };
    version = "7.1.5-ogc2";
    modDirVersion = "7.1.5";
  };

  structuredExtraConfig = with lib.kernel; {
    HID_ASUS_ALLY = module;
  };
}
