# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs:
let
  cPkg = pkgs.callPackage;
  fonts = import ./fonts { inherit pkgs; };
in
rec {
  _beatSaberModManager = cPkg ./BeatSaberModManager/BeatSaberModManager.nix { };
  _fish-ai = cPkg ./fishPlugins/fish-ai.nix { };
  _gamma-launcher = cPkg ./gamma-launcher.nix { };
  _anchorr = cPkg ./anchorr/default.nix { };
  _homeassistant-desktop = cPkg ./homeassistant-desktop/default.nix { };
  _openmw-vr = cPkg ./openmw-vr/openmw-vr.nix { };

  #--- APPEARANCE ---#
  inherit fonts;
  _volantes-hyprcursor = cPkg ./volantes_hyprcursor/default.nix { };

  #--- BIN ---#
  _waydroid-hide-desktop-entries = cPkg ./bin/waydroid-hide-desktop-entries.nix { };

  #--- M O D E L  C O N T E X T  P R O T O C O L ---#
  _mpd-mcp-server = cPkg ./mcp/mpd-mcp-server/default.nix { };
  _jellyseerr-mcp = cPkg ./mcp/jellyseerr-mcp/default.nix { };
  _screenpipe = cPkg ./screenpipe/package.nix { };

  #--- Programming ---#
  fennelPackages._antifennel = cPkg ./antifennel.nix { };

  #--- Kernels ---#
  # Import directly so callPackage does not replace the kernel derivation's
  # own `override` method, which linuxPackagesFor and NixOS rely on.
  linux-ogc = import ./kernel/ogc-kernel {
    inherit (pkgs) fetchFromGitHub lib linuxPackages_7_1;
  };

  #--- Proton Versions ---#
  _dwproton = cPkg ./proton-dw.nix { };
  _proton-ge-rtsp = cPkg ./proton-ge-rtsp.nix { };

  _headroom = cPkg ./headroom/default.nix { };
  _xhisper-local = cPkg ./xhisper-local/default.nix { };
}
