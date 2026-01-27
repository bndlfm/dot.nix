# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs:
let
  cPkg = pkgs.callPackage;
in
{
  fennelPackages._antifennel = cPkg ./antifennel.nix { };
  _beatSaberModManager = cPkg ./BeatSaberModManager/BeatSaberModManager.nix { };
  _moltbot = cPkg ./moltbot/default.nix {};
  _fish-ai = cPkg ./fishPlugins/fish-ai.nix { };
  _gamma-launcher = cPkg ./gamma-launcher.nix { };
  _openmw-vr = cPkg ./openmw-vr/openmw-vr.nix { };
  _proton-ge-rtsp = cPkg ./proton-ge-rtsp.nix { };

  # BIN
  _waydroid-hide-desktop-entries = cPkg ./bin/waydroid-hide-desktop-entries.nix { };
  _waydroid-script = cPkg ./waydroid-script/waydroid-script.nix { };
}
