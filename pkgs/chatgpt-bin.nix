{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  gawk,
  gnupg,
  libarchive,
  makeWrapper,
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libglvnd,
  libnotify,
  libsecret,
  libusb1,
  libX11,
  libxcb,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libxkbcommon,
  libXrandr,
  libXScrnSaver,
  mesa,
  nspr,
  nss,
  openssl,
  pango,
  qt5,
  qt6,
  systemd,
  tpm2-tss,
  vulkan-loader,
  xdg-utils,
  xz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chatgpt-bin";
  version = "26.930.61225";

  src = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/arch/26.930.61225/x86_64/chatgpt-bin-26.930.61225-1-x86_64.pkg.tar.zst";
    hash = "sha256-lzxjh8KqrsVH9o86ibKV+9HXv49xdt+/UBtHWlVF95U=";
  };

  repositorySigningKey = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/arch/26.930.61225/repository-signing-key.gpg";
    hash = "sha256-I+LPve9q/pVQX56VostjWF2n/+mwalHsCKMkB8hH1ZY=";
  };

  signature = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/arch/26.930.61225/x86_64/chatgpt-bin-26.930.61225-1-x86_64.pkg.tar.zst.sig";
    hash = "sha256-ivJiCB7SLWbxd20v+NhdTQYrHpiedvm4RFErsavIUFI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    gnupg
    libarchive
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libglvnd
    libnotify
    libsecret
    libusb1
    libX11
    libxcb
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libxkbcommon
    libXrandr
    libXScrnSaver
    mesa
    nspr
    nss
    openssl
    pango
    systemd
    tpm2-tss
    vulkan-loader
    xdg-utils
    xz
  ];

  # The upstream archive contains optional musl prebuilds alongside the
  # glibc x86_64 binaries used on this host.
  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
  ];

  autoPatchelfSearchPath = [
    "${qt5.qtbase}/lib"
    "${qt6.qtbase}/lib"
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    export GNUPGHOME="$TMPDIR/gnupg"
    mkdir -m 0700 "$GNUPGHOME"
    fingerprint="$(${gnupg}/bin/gpg --batch --with-colons --import-options show-only --import "$repositorySigningKey" \
      | ${gawk}/bin/awk -F: '$1 == "fpr" { print $10; exit }')"
    test "$fingerprint" = "3BFA0E4AE8B8CC16A2D9BA684A3B4A566C4660E4"
    ${gnupg}/bin/gpg --batch --import "$repositorySigningKey"
    ${gnupg}/bin/gpg --batch --no-auto-key-retrieve --no-auto-key-import \
      --verify "$signature" "$src"

    mkdir -p "$out"
    ${libarchive}/bin/bsdtar --zstd -xf "$src" -C "$out" --strip-components=1
    rm "$out/bin/chatgpt"
    makeWrapper "$out/lib/chatgpt/codex-launcher" "$out/bin/chatgpt" \
      --prefix LD_LIBRARY_PATH : "${qt5.qtbase}/lib:${qt6.qtbase}/lib"
    install -Dm644 "$out/lib/chatgpt/resources/icon-chatgpt.png" \
      "$out/share/icons/hicolor/512x512/apps/chatgpt.png"
    runHook postInstall
  '';

  meta = {
    description = "ChatGPT desktop application by OpenAI";
    homepage = "https://developers.openai.com/codex/app";
    license = lib.licenses.unfree;
    mainProgram = "chatgpt";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
