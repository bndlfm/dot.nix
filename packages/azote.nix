{
  gtk3,
  imagemagick,
  grim,
  slurp,
  libappindicator-gtk3,
  swaybg,
  wlr-randr,

  # Build Tools
  makeWrapper,
  setuptools
}:

let
  pkgs = import <nixpkgs> {};
  pipDeps = with pkgs.python3Packages; [
    pygobject3
    pillow
    pycairo
    send2trash
    pyyaml
  ];
in


  pkgs.python3Packages.buildPythonPackage rec {
    pname = "azote";
    version = "1.12.19";
    format = "setuptools";

    src = pkgs.fetchFromGitHub {
      owner = "nwg-piotr";
      repo = "azote";
      rev = "v${version}";
      hash = pkgs.lib.fakeSha256;
    };

    #dependencies = pipDeps;

    build-system = pkgs.python3Packages.setuptools;

    propagatedBuildInputs = pipDeps ++[
      imagemagick
      grim
      slurp
      libappindicator-gtk3
      swaybg
      wlr-randr
      gtk3
    ];

    nativeBuildInputs = [
      makeWrapper
      setuptools
    ];

    postInstall = /* sh */ ''
      wrapProgram $out/bin/azote --prefix PATH : ${pkgs.lib.makeBinPath [
        pkgs.imagemagick
        pkgs.grim
        pkgs.slurp
        pkgs.libappindicator-gtk3
        pkgs.swaybg
        pkgs.wlr-randr
      ]}
    '';

    meta = with pkgs.lib; {
      description = "Wallpaper Manager for Sway, Hyperland, etc";
      homepage = "https://github.com/nwg-piotr/azote";
      license = licenses.gpl3;  # Adjust if the license is different
      maintainers = with maintainers; [  ];  # Add maintainers if known
    };

    # installPhase = /* sh */ ''
    #  mkdir -p $out/bin $out/share/${pname}
    #  cp -R ./* $out/share/${pname}

    #  for file in $out/share/${pname}/*.py; do
    #    if [ -f "$file" ]; then
    #      filename=$(basename "$file")
    #      makeWrapper ${pythonWithPackages}/bin/python $out/bin/''${filename%.py} \
    #        --add-flags "$out/share/${pname}/$filename" \
    #        --prefix PYTHONPATH : $out/share/${pname}
    #    fi
    #  done
    #'';
}
