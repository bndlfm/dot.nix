{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  python3Packages,
  nftables,
  dnsmasq,
  gtk3,
  dbus,
  lxc,
  wnv-src,
}:

let
  waydroid-src = fetchFromGitHub {
    owner = "waydroid";
    repo = "waydroid";
    rev = "a33a5c0b31d89d6ce687381104b30aff4dd2d330";
    hash = "sha256-V8TTnfnsujDnW9Q2SZN/+2jPxxtWLbiSTydK8Jv4QS0=";
  };
  python = python3.withPackages (ps: with ps; [
    pygobject3
    dbus-python
    gbinder-python
    lxc
  ]);
in
stdenv.mkDerivation {
  pname = "waydroid-nvidia";
  version = "0.1.2";
  src = waydroid-src;
  patches = [ "${wnv-src}/patches/waydroid/0001-nvidia-integration.patch" ];
  nativeBuildInputs = [ python ];
  buildInputs = [ nftables dnsmasq gtk3 dbus lxc ];
  dontConfigure = true;
  buildPhase = "true";
  installPhase = ''
    patchShebangs tools
    make install DESTDIR=$out USE_NFTABLES=1 PREFIX=
    patchShebangs $out/lib/waydroid
  '';
  meta = {
    description = "Waydroid patched for the waydroid-nvidia Venus stack";
    homepage = "https://github.com/Shiro836/waydroid-nvidia";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
