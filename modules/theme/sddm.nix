{ stdev, lib, fetchFromGitLab }:
{
  sddm-lain-theme = stdev.mkDerivation rec {
    pname = "sddm-lain-wired-theme";
    version = "1.0";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/sddm-lain-theme
      cp -aR $src $out/share/sddm/themes/sddm-lain-theme
    '';
    src = fetchFromGitLab {
      owner = "mixedCase";
      repo = "sddm-lain-wired-theme";
      rev = "v${version}";
      sha256 = "4c98a329d62d40658657a2a4f54c44fe522c6117";
    };
  };
}
