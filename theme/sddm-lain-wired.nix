{ stdenv, fetchFromGitLab }:
{
  sddm-lain-wired-theme = stdenv.mkDerivation {
    pname = "sddm-lain-wired-theme";
    version = "1.0";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/sddm-lain-wired-theme
      cp -aR $src $out/share/sddm/themes/sddm-lain-wired-theme
    '';
    src = fetchFromGitLab {
      owner = "mixedCase";
      repo = "sddm-lain-wired-theme";
      rev = "master";
      sha256 = "0vaxd2ic5qmkwqivjdspbvkrr8ihp6rzq3hi42dryn4bn2w0nzps";
    };
  };
}
