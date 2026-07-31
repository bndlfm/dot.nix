{ pkgs, lib, ... }:

let
  ogcSrc = pkgs.fetchFromGitHub {
    owner = "OpenGamingCollective";
    repo = "linux";
    rev = "e5f0343e484d49258c70e9c128570cb93195ce21"; # tag v7.1.5-ogc2
    hash = "sha256-T3BPgb5utVa+F5ZCUUDEV+ae0AnB0Pmz8JMu+Jv5Qk8=";
  };

  ogcKernel = pkgs.linuxPackages_latest.kernel.override {
    argsOverride = {
      src = ogcSrc;
      version = "7.1.5-ogc2";
      modDirVersion = "7.1.5";
    };
    structuredExtraConfig = with lib.kernel; {
      HID_ASUS_ALLY = module;
    };
  };

  ogcKernelPackages = pkgs.linuxPackagesFor ogcKernel;
in
{
  boot.kernelPackages = lib.mkOverride 10 ogcKernelPackages;
}
