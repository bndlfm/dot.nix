# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: let
  cPkg = pkgs.callPackage;
in{
  antifennel = pkgs.callPackage ./antifennel.nix { };
  azote = pkgs.callPackage ./azote.nix { };
  beatSaberModManager = pkgs.callPackage ./BeatSaberModManager/BeatSaberModManager.nix { };
  fishai = pkgs.callPackage ./fish-ai.nix { };
  gamma-launcher = pkgs.callPackage ./gamma-launcher.nix { };
  gsh = pkgs.callPackage ./generativeShell.nix { };
  ndrop = pkgs.callPackage ./ndrop.nix { };
  openmw-vr = pkgs.callPackage ./openmw-vr/openmw-vr.nix { };
  proton-ge-rtsp = cPkg ./proton-ge-rtsp.nix { };
  vintageStory = cPkg ./vintageStory.nix { };
}
