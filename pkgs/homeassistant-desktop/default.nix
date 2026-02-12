{ lib
, buildNpmPackage
, electron
, fetchFromGitHub
, makeWrapper
}:

buildNpmPackage rec {
  pname = "homeassistant-desktop";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "bndlfm";
    repo = "homeassistant-desktop";
    rev = "7b4e77c7f74a9ab89efe64313d28265f69b202c5";
    hash = "sha256-p0wUa+71OraRyceoh8q5hh9YTzgsgSfyGYgzGVNB9b4=";
  };

  npmDepsHash = "sha256-yrNGWqv13os54k5H7HpOPui/H8qQ1KHEh9oJG23cCW0=";
  dontNpmBuild = true;
  npmInstallFlags = [ "--ignore-scripts" "--omit=dev" ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${pname}
    cp -r . $out/share/${pname}

    mkdir -p $out/bin
    makeWrapper ${lib.getExe electron} $out/bin/${pname} \
      --add-flags "$out/share/${pname}/app.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Desktop App for Home Assistant built with Electron";
    homepage = "https://github.com/iprodanovbg/homeassistant-desktop";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = pname;
    maintainers = [ ];
  };
}
