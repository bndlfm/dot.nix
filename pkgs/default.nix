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
  _obsidian-cli = cPkg ./obsidian-cli/default.nix { };
  _gifgrep = cPkg ./gifgrep/default.nix { };
  _bird = cPkg ./bird/default.nix { };
  _blogwatcher = cPkg ./blogwatcher/default.nix { };
  _goplaces = cPkg ./goplaces/default.nix { };
  _mcporter = cPkg ./mcporter/default.nix { };
  _songsee = cPkg ./songsee/default.nix { };
  _spogo = cPkg ./spogo/default.nix { };
  _summarize = cPkg ./summarize/default.nix { };
  _sag = cPkg ./sag/default.nix { };
  _nano-pdf = cPkg ./nano-pdf/default.nix { };
  _camsnap = cPkg ./camsnap/default.nix { };
  _gogcli = cPkg ./gogcli/default.nix { };
  _proton-ge-rtsp = cPkg ./proton-ge-rtsp.nix { };

  # BIN
  _waydroid-hide-desktop-entries = cPkg ./bin/waydroid-hide-desktop-entries.nix { };
  _waydroid-script = cPkg ./waydroid-script/waydroid-script.nix { };
}
