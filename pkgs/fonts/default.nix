{ pkgs, ... }:
{
  _ioskeley = pkgs.callPackage ./ioskeley-mono.nix { };
}
