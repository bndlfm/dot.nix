{ stdenv, lib, fetchFromGitLab }:
{
  sddm-lain-theme = stdenv.mkDerivation rec {
    pname = "sddm-lain-theme";
    version = "1.0";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/sddm-lain-theme
      cp -aR $src $out/share/sddm/themes/sddm-lain-theme
    '';
    src = fetchFromGitLab {
      owner = "mixedCase";
      repo = "sddm-lain-wired-theme";
      rev = "master";
      sha256 = "0vaxd2ic5qmkwqivjdspbvkrr8ihp6rzq3hi42dryn4bn2w0nzps";
    };
  };
}
