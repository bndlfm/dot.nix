{ ... }:
let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in {
  home.packages = [
    # GENSHIN
      aagl-gtk-on-nix.anime-game-launcher
  ];
}
