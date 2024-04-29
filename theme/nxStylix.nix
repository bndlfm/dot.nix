{ pkgs, ... }: {
  stylix = {
    autoEnable = false;
    polarity = "dark";
    image = ./wallpapers/eve-blue-girl.jpg;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

    cursor = {
      name = "volantes_light_cursors";
      package = pkgs.volantes-cursors;
      size = 32;
    };

    fonts = {
      serif = {
        package = pkgs.inconsolata-nerdfont;
        name = "Inconsolata Nerd Font";
      };

      sansSerif = {
        package = pkgs.gyre-fonts;
        name = "TeX Gyre Heros";
      };

      monospace = {
        package = pkgs.nerdfonts;
        name = "Inconsolata Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji-blob-bin;
        name = "Noto Color Emoji";
      };
    };

    targets = {
      chromium.enable = true;
      gtk.enable = true;
    };
  };
}
