{ nixpkgs, ... }:

let
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
in {
  stylix = {
    autoEnable = false;
    polarity = "dark";
    image = ./wallpapers/vampire-hunter-d-yoshitaka-amano.jpg;

    base16Scheme =  "${pkgs.base16-schemes}/share/themes/nord.yaml";

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

      cursor = {
        package = pkgs.volantes-cursors;
        name = "Volantes Light Cursors";
        size = 24;
      };

    targets = {
      /*cursor.enable = false;*/
      fish.enable = true;
      chromium.enable = true;
      gtk.enable = true;
    };
  };
}
