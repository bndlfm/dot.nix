{
  lib,
  stdenv,
  makeWrapper,
  lxc,
  kmod,
  iptables,
  nftables,
  iproute2,
  dnsmasq,
  util-linux,
  gawk,
  getent,
  binutils,
  python3,
  wnv-src,
  waydroid-nvidia,
  virglrenderer-nvidia,
  guest-nvidia,
  guest-prebuilts-nvidia,
}:

stdenv.mkDerivation {
  pname = "waydroid-nvidia-full";
  version = "0.1.2";
  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ${waydroid-nvidia}/* $out/
    chmod -R u+w $out

    mkdir -p $out/lib/waydroid-nvidia
    cp -L ${virglrenderer-nvidia}/lib/waydroid-nvidia/* $out/lib/waydroid-nvidia/
    mkdir -p $out/lib/waydroid-nvidia/guest
    for guest_dir in ${guest-nvidia}/lib/waydroid-nvidia/guest ${guest-prebuilts-nvidia}/lib/waydroid-nvidia/guest; do
      while IFS= read -r -d "" f; do
        rel="''${f#$guest_dir/}"
        install -Dm644 "$f" "$out/lib/waydroid-nvidia/guest/$rel"
      done < <(find "$guest_dir" -type f -print0)
    done
    chmod 755 $out/lib/waydroid-nvidia/guest/system/bin/surfaceflinger

    mkdir -p $out/lib/tmpfiles.d $out/lib/udev/rules.d
    cp ${wnv-src}/packaging/aur/waydroid-nvidia-bin/waydroid-venus.tmpfiles $out/lib/tmpfiles.d/waydroid-venus.conf
    cp ${wnv-src}/packaging/aur/waydroid-nvidia-bin/waydroid-nvidia.rules $out/lib/udev/rules.d/70-waydroid-nvidia.rules
    cp ${wnv-src}/packaging/aur/waydroid-nvidia-bin/waydroid-nvidia-setup $out/bin/waydroid-nvidia-setup
    chmod 755 $out/bin/waydroid-nvidia-setup
    substituteInPlace $out/bin/waydroid-nvidia-setup \
      --replace-fail /usr/lib/waydroid-nvidia $out/lib/waydroid-nvidia
    substituteInPlace $out/lib/waydroid/tools/helpers/images.py \
      --replace-fail "system_response['url'], system_response['filename'], cache=False" \
        "system_response['url'], system_response['filename'], cache=True" \
      --replace-fail "vendor_response['url'], vendor_response['filename'], cache=False" \
        "vendor_response['url'], vendor_response['filename'], cache=True"
    substituteInPlace $out/bin/waydroid-nvidia-setup \
      --replace-fail 'NV_GUEST=$NV/guest' 'NV_GUEST=$NV/guest
OVERLAY=/var/lib/waydroid/overlay' \
      --replace-fail 'install -Dm 0644 "$GUEST/$rel" "$NV_GUEST/$rel"' 'install -Dm 0644 "$GUEST/$rel" "$NV_GUEST/$rel"
    install -Dm 0644 "$GUEST/$rel" "$OVERLAY/$rel"' \
      --replace-fail 'install -Dm 0755 "$GUEST/$rel" "$NV_GUEST/$rel"' 'install -Dm 0755 "$GUEST/$rel" "$NV_GUEST/$rel"
    install -Dm 0755 "$GUEST/$rel" "$OVERLAY/$rel"'

    wrapProgram $out/bin/waydroid-nvidia-setup \
      --prefix PATH : ${lib.makeBinPath [ binutils python3 util-linux ]}:$out/bin
    wrapProgram $out/bin/waydroid --prefix PATH : ${lib.makeBinPath [ lxc kmod util-linux ]}
    wrapProgram $out/lib/waydroid/data/scripts/waydroid-net.sh \
      --prefix PATH : ${lib.makeBinPath [ lxc kmod iptables nftables iproute2 dnsmasq gawk getent ]}

    for f in \
      $out/bin/waydroid $out/bin/waydroid-nvidia-setup \
      $out/lib/waydroid-nvidia/virgl_test_server \
      $out/lib/waydroid-nvidia/virgl_render_server \
      $out/lib/waydroid-nvidia/guest/vendor/lib64/hw/vulkan.virtio.so \
      $out/lib/waydroid-nvidia/guest/vendor/lib/hw/vulkan.virtio.so \
      $out/lib/waydroid-nvidia/guest/vendor/lib64/libgbm_mesa_wrapper.so \
      $out/lib/waydroid-nvidia/guest/vendor/lib64/hw/hwcomposer.waydroid.so \
      $out/lib/waydroid-nvidia/guest/system/bin/surfaceflinger \
      $out/lib/tmpfiles.d/waydroid-venus.conf \
      $out/lib/udev/rules.d/70-waydroid-nvidia.rules; do
      test -f "$f" || { echo "waydroid-nvidia: missing $f" >&2; exit 1; }
    done
  '';
  meta = {
    description = "Complete NVIDIA-accelerated Waydroid stack using Mesa Venus";
    homepage = "https://github.com/Shiro836/waydroid-nvidia";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "waydroid";
  };
}
