# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  antifennel = pkgs.callPackage ./antifennel.nix { };
  azote = pkgs.callPackage ./azote.nix { };
  beatSaberModManager = pkgs.callPackage ./BeatSaberModManager/BeatSaberModManager.nix { };
  ndrop = pkgs.callPackage ./ndrop.nix { };
  proton-ge-rtsp = ./proton-ge-rtsp.nix { };
  openmw-vr = pkgs.callPackage ./openmw-vr/openmw-vr.nix { };
}
