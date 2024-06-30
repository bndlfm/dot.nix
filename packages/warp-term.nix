{
  pkgs,
  ...
}:

pkgs.appimageTools.wrapType2 rec {
  name = "warp-terminal";
  version = "0.2024.06.18.08.02.stable_04";
  src = pkgs.fetchurl {
    url = "https://releases.warp.dev/stable/v${version}/Warp-x86_64.AppImage";
    hash = "sha256-5Gf1tpgVkuuQ1jlfXxZJsdVWnuocypK3lNWWK/yjcDQ=";
  };
  extraPkgs = pkgs: with pkgs; [ pkgs.curl pkgs.makeWrapper ];
  #extraInstallCommands = ''
  #  wrapProgram $out/bin/warp-terminal --set WARP_ENABLE_WAYLAND 1 \
  #    --prefix LD_LIBRARY_PATH : ${pkgs.wayland}/lib
  #'';
}

#pkgs.warp-terminal.overrideAttrs (old: rec {
#  pname = "warp-terminal";
#  version = "0.2024.06.18.08.02.stable_04";
#  src = pkgs.fetchurl {
#    url = "https://releases.warp.dev/stable/v${version}/warp-terminal-v${version}-1-x86_64.pkg.tar.zst";
#    sha256 = "sha256-8/9VgkKU7VO7m0Mgx24vM2Bv6+yqcSlhPLZ1slCTCEc=";
#  };
#  nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper pkgs.curl ];
#  postInstall = ''
#    wrapProgram $out/bin/warp-terminal --set WARP_ENABLE_WAYLAND 1 \
#    	--prefix LD_LIBRARY_PATH : ${pkgs.wayland}/lib
#  '';
#})
