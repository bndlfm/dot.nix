{ ... }:
let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{
  home.packages = {
    # GENSHIN
    aagl-gtk-on-nix.anime-game-launcher.enable = true;
    # HONKAI
    aagl-gtk-on-nix.anime-games-launcher.enable = false;
    aagl-gtk-on-nix.honkers-launcher.enable = false;
    aagl-gtk-on-nix.honkers-railway-launcher.enable = false;
    # PUNISHING GRAY RAVEN
    aagl-gtk-on-nix.anime-borb-launcher.enable = false;
    # WUTHERING WAVES
    aagl-gtk-on-nix.wavey-launcher.enable = false;
    # ZENLESS ZONE ZERO
    aagl-gtk-on-nix.sleepy-launcher.enable = true;
  };
}
