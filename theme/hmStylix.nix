{ nixpkgs, ... }:
let
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
  theme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  /*wallpaper = pkgs.runCommand "image.png" {} ''
        COLOR=$(${pkgs.yq}/bin/yq -r .base00 ${theme})
        COLOR="#"$COLOR
        ${pkgs.imagemagick}/bin/magick convert -size 1920x1080 xc:$COLOR $out
  ''; */
in {
  stylix = {
    autoEnable = false;

    image =  ./wallpapers/vampire-hunter-d-yoshitaka-amano.jpg;
    base16Scheme = theme;
    polarity = "dark";

    opacity = {
      desktop = 1;
      popups = 0.85;
      terminal = 0.9;
    };

    cursor = {
      name = "volantes_light_cursors";
      package = pkgs.volantes-cursors;
      size = 32;
    };

    targets = {
      bat.enable = true;
      bspwm.enable = true;
      btop.enable = true;
      dunst.enable = true;
      firefox.enable = true;
      fish.enable = true;
      fzf.enable = true;
      gtk.enable = true;
      hyprland.enable = true;
      kde.enable = true;
      kitty.enable = true;
      lazygit.enable = true;
      qutebrowser.enable = true;
      rofi.enable = true;
      swaylock = {
        enable = true;
        useImage = false;
      };
      waybar = {
        enable = true;
        enableCenterBackColors = false;
        enableLeftBackColors = false;
        enableRightBackColors = false;
      };
      xresources.enable = true;
      yazi.enable = true;
      zathura.enable = true;
      zellij.enable = true;
    };
  };
}
