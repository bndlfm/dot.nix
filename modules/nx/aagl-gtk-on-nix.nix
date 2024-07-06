# For playing various GACHA games on Linux
{ config, pkgs, ... }:
let
  aagl-gtk-on-nix = import (builtins.fetchTarball {
    url = "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz";
    sha256 = "1dbm2zml39vwz5cn7r383llc37xdmj051qdab9ijpg6q5a76h6m7"; # Replace with actual SHA256
  });
  # Uncomment and use this instead if you want to use a specific release
  # aagl-gtk-on-nix = import (builtins.fetchTarball {
  #   url = "https://github.com/ezKEa/aagl-gtk-on-nix/archive/release-24.05.tar.gz";
  #   sha256 = "0000000000000000000000000000000000000000000000000000"; # Replace with actual SHA256
  # });
  # aaglPkgs = aagl-gtk-on-nix.withNixpkgs pkgs;
in
{
  imports = [
    aagl-gtk-on-nix.module
    # aaglPkgs.module
  ];
  programs.anime-game-launcher.enable = true;
  programs.anime-games-launcher.enable = true;
  programs.anime-borb-launcher.enable = false;
  programs.honkers-railway-launcher.enable = false;
  programs.honkers-launcher.enable = false;
  programs.wavey-launcher.enable = false;
  programs.sleepy-launcher.enable = true;
}
