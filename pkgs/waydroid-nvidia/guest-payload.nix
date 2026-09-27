{
  lib,
  stdenv,
  fetchurl,
  zstd,
  version ? "0.1.2",
  kind,
}:

let
  name = if kind == "guest" then "waydroid-nvidia-guest-android-x86_64-v${version}.tar.zst"
    else "waydroid-nvidia-guest-prebuilts-v${version}.tar.zst";
  hash = if kind == "guest" then "sha256-wKbuemnGvGB19xl9bDzC4hO/GwYbAy8g2m90QfhwRXQ="
    else "sha256-YYmfVsIDt1DUH3wUGh7iZMtoJBdIzJzaUS7UXymXy9E=";
  src = fetchurl {
    inherit name hash;
    url = "https://github.com/Shiro836/waydroid-nvidia/releases/download/v${version}/${name}";
  };
in
stdenv.mkDerivation {
  pname = "waydroid-nvidia-${kind}";
  inherit version src;
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  nativeBuildInputs = [ zstd ];
  installPhase = ''
    mkdir -p $out/lib/waydroid-nvidia/guest
    tar --zstd -xf "$src" -C $out/lib/waydroid-nvidia/guest --strip-components=1
  '';
  meta = {
    description = "${kind} payload for waydroid-nvidia";
    homepage = "https://github.com/Shiro836/waydroid-nvidia";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
