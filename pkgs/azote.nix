{ pkgs ? import <nixpkgs> {} }:
  pkgs.python3Packages.buildPythonApplication rec {
    pname = "azote";
    version = "1.14.1";

    src = pkgs.fetchFromGitHub {
      owner = "nwg-piotr";
      repo = "azote";
      rev = "v${version}";
      hash = "sha256-HXBzskpCUcIujahY7moIU4DCMhd4nGsdwGqbQHOL4P0=";
    };

    build-system = with pkgs.python3Packages; [
      setuptools
    ];

    dependencies = with pkgs.python3Packages; [
      pillow
      pygobject3
      send2trash
      setuptools
      pyxdg
      pyyaml
    ];

    nativeBuildInputs = with pkgs; [
      gtk3
      glib
      gobject-introspection
      wrapGAppsHook3
    ];

    buildInputs = with pkgs; [
      imagemagick
      libsoup_2_4
      libappindicator-gtk3
    ];

    propagatedBuildInputs = with pkgs; [
      ## For sway / wlroots
      grim
      slurp
      swaybg
      sway-contrib.grimshot
      wlr-randr

      ## X11
      feh
      slop
      xorg.libX11
    ];

    meta = with pkgs.lib; {
      homepage = "https://github.com/nwg-piotr/azote";
      description = "Wallpaper manager for sway and some other WMs";
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ bndlfm ];
    };
}
