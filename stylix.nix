{ nixpkgs, system, ... }:
let
  pkgs = import nixpkgs {
    inherit system;
  };
in
{
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
}
