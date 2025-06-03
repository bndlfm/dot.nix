# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs:
  let
    cPkg = pkgs.callPackage;
  in
    {
      _antifennel = cPkg ./antifennel.nix {};
      _azote = cPkg ./azote.nix {};
      _beatSaberModManager = cPkg ./BeatSaberModManager/BeatSaberModManager.nix {};
      _fish-ai = cPkg ./fishPlugins/fish-ai.nix {};
      _gamma-launcher = cPkg ./gamma-launcher.nix {};
      _gsh = cPkg ./generativeShell.nix {};
      _ndrop = cPkg ./ndrop.nix {};
      _openmw-vr = cPkg ./openmw-vr/openmw-vr.nix {};
      _phoneinfoga = cPkg ./phoneinfoga.nix {};
      _proton-ge-rtsp = cPkg ./proton-ge-rtsp.nix {};
      _vintagestory = cPkg ./vintageStory.nix {};
      _waydroid-hide-desktop-entries = cPkg ./bin/waydroid-hide-desktop-entries.nix {};
      _waydroid-script = cPkg ./waydroid-script/waydroid-script.nix {};
    }
