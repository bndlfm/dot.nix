{ lib
, buildNpmPackage
, fetchurl
}:

buildNpmPackage rec {
  pname = "clawdhub";
  version = "0.3.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/clawdhub/-/clawdhub-${version}.tgz";
    hash = "sha256-BVzm7F+wPt6PvpHsounvn/bim8MpKLkyzfaReMGphDA=";
  };

  dontNpmBuild = true;
  npmDepsHash = "sha256-iRg8mAVcKk2UJLFLS43dKw3hB4LTZRDSqqvdoyxcrvA=";
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  meta = with lib; {
    description = "ClawdHub CLI — install, update, search, and publish agent skills.";
    homepage = "https://github.com/openclaw/clawhub";
    license = licenses.mit;
    mainProgram = "clawdhub";
  };
}
