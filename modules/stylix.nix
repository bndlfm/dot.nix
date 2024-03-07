{ lib, nixpkgs, ... }@inputs: {
  stylix = {
    autoEnable = false;
    base16Scheme = "${inputs.tt-schemes}/base16/nord.yaml";
    polarity = "dark";
    image = ./Wallpaper/2016-05-02-1462223680-7138559-BD_PRESS_KIT__1.326.1.jpg;

    fonts = {
      serif = {
        package = nixpkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      #  sansSerif = {
      #    package = pkgs.dejavu_fonts;
      #    name = "DejaVu Sans";
      #  };

      #  monospace = {
      #    package = pkgs.dejavu_fonts;
      #    name = "DejaVu Sans Mono";
      #  };

      #  emoji = {
      #    package = pkgs.noto-fonts-emoji;
      #    name = "Noto Color Emoji";
      #  };
    };

    #cursor = {
    #  package = pkgs.volantes-cursors;
    #  name = "volantes-cursors";
    #  size = 32;
    #};

    targets = {
      gtk.enable = true;
    };
  };
}
