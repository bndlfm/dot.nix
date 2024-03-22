
  #xorg = super.xorg.overrideScope (xself: xsuper: {
  #xorgproto = xsuper.xorgproto.overrideAttrs (oldAttrs: {
  #  patches = ( oldAttrs.patches or [] ) ++ [
  #    ( super.fetchpatch {
  #      url = "https://gitlab.freedesktop.org/xorg/proto/xorgproto/-/merge_requests/59.patch";
  #      sha256 = "sha256-AOFfuEjijppMtwHhuOWFOV7pyuKPoEsKpLZN6E0NToI=";
  #      })
  #    ];
  #  });
  #});

  #xwayland = super.xwayland.overrideAttrs (oldAttrs: {
  #  src = super.fetchFromGitLab {
  #    domain = "git@gitlab.freedesktop.org";
  #    owner = "ekurzinger";
  #    repo = "xserver";
  #    rev = "8b2c17156220ac230516a4fc50340d8750663df5";
  #    sha256 = "sha256-mOzQnHUDyedNNSmqIRUIJY37XmvGsuXY3R+Xmculhs0=";
  #    };
  #  nativeBuildInputs = oldAttrs.buildInputs ++ [ pkgs.pkg-config ];
  #  buildInputs = oldAttrs.buildInputs ++ [ pkgs.systemd ];
  #patches = ( oldAttrs.patches or [] ) ++ [
  #  (super.fetchpatch {
  #    url = "https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/967.patch";
  #    sha256 = "sha256-ZWCgO1HZO/3IfWKDQ3r+Sh1+jqcEl+bt3EOgBZ1lulc=";
  #    })
  #  ];
  #});

  #wayland-protocols = super.wayland-protocols.overrideAttrs (oldAttrs: {
  #  patches = ( oldAttrs.patches or [] ) ++ [
  #    ( super.fetchpatch  {
  #      url = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/90.patch";
  #      sha256 = "sha256-OexA9UdMthag7PeQlqmZTFBZXmui2BgjXWGJ5rxJA3g=";
  #      })
  #    ];
  #  });
