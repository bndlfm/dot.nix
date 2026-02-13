# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs:
let
  cPkg = pkgs.callPackage;
in
{
  fennelPackages._antifennel = cPkg ./antifennel.nix { };
  _beatSaberModManager = cPkg ./BeatSaberModManager/BeatSaberModManager.nix { };
  _fish-ai = cPkg ./fishPlugins/fish-ai.nix { };
  _gamma-launcher = cPkg ./gamma-launcher.nix { };
  _homeassistant-desktop = cPkg ./homeassistant-desktop/default.nix { };
  _openmw-vr = cPkg ./openmw-vr/openmw-vr.nix { };
  _proton-ge-rtsp = cPkg ./proton-ge-rtsp.nix { };
  _noctalia-plugin-ai-usage = cPkg ./noctalia/plugins/ai-usage/default.nix { };

  #--- Openclaw CLIs ---#
  _openclaw = cPkg ./openclaw/default.nix { };
  _bird = cPkg ./openclaw/plugins/bird/default.nix { };
  _blogwatcher = cPkg ./openclaw/plugins/blogwatcher/default.nix { };
  _camsnap = cPkg ./openclaw/plugins/camsnap/default.nix { };
  _clawdhub = cPkg ./openclaw/plugins/clawdhub/default.nix { };
  _gifgrep = cPkg ./openclaw/plugins/gifgrep/default.nix { };
  _gogcli = cPkg ./openclaw/plugins/gogcli/default.nix { };
  _goplaces = cPkg ./openclaw/plugins/goplaces/default.nix { };
  _mcporter = cPkg ./openclaw/plugins/mcporter/default.nix { };
  _nano-pdf = cPkg ./openclaw/plugins/nano-pdf/default.nix { };
  _songsee = cPkg ./openclaw/plugins/songsee/default.nix { };
  _summarize = cPkg ./openclaw/plugins/summarize/default.nix { };
  _sag = cPkg ./openclaw/plugins/sag/default.nix { };

  #--- M O D E L  C O N T E X T  P R O T O C O L ---#
  _mpd-mcp-server = cPkg ./mcp/mpd-mcp-server/default.nix { };
  _mcp-arr = cPkg ./mcp/mcp-arr/default.nix { };

  #--- BIN ---#
  _waydroid-hide-desktop-entries = cPkg ./bin/waydroid-hide-desktop-entries.nix { };
  _waydroid-script = cPkg ./waydroid-script/waydroid-script.nix { };
}
