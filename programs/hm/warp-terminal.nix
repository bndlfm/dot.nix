{
  pkgs,
  ...
}:
pkgs.warp-terminal.overrideAttrs (old: rec {
  pname = "warp-terminal";
  version = "0.2024.06.18.08.02.stable_04";
  src = pkgs.fetchurl {
    url = "https://releases.warp.dev/stable/v${version}/warp-terminal-v${version}-1-x86_64.pkg.tar.zst";
    hash = "sha256-8/9VgkKU7VO7m0Mgx24vM2Bv6+yqcSlhPLZ1slCTCEc=";
  };
  nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.makeWrapper];
  postInstall = ''
    wrapProgram $out/bin/warp-terminal --set WARP_ENABLE_WAYLAND 1 \
    	--prefix LD_LIBRARY_PATH : ${pkgs.wayland}/lib
  '';
})
