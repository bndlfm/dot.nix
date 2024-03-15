{ nixpkgs, ... }:

let
  pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
in {
  stylix = {
    autoEnable = false;
    polarity = "dark";
    image = ../wallpapers/2016-05-02-1462223680-7138559-BD_PRESS_KIT__1.326.1.jpg;

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
      name = "volantes-cursors";
      size = 32;
    };

    targets = {
      gtk.enable = true;
    };
  };
}
