# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: let
  cPkg = pkgs.callPackage;
in{
  antifennel = cPkg ./antifennel.nix { };
  azote = cPkg ./azote.nix { };
  beatSaberModManager = cPkg ./BeatSaberModManager/BeatSaberModManager.nix { };
  fishai = cPkg ./fish-ai.nix { };
  gamma-launcher = cPkg ./gamma-launcher.nix { };
  gsh = cPkg ./generativeShell.nix { };
  ndrop = cPkg ./ndrop.nix { };
  openmw-vr = cPkg ./openmw-vr/openmw-vr.nix { };
  pass2bw = cPkg ./pass2bw.nix { };
  pass2bitwarden = cPkg ./pass2bitwarden.nix { };
  pass-export = cPkg ./pass-export.nix { };
  proton-ge-rtsp = cPkg ./proton-ge-rtsp.nix { };
  vintageStory = cPkg ./vintageStory.nix { };
}
