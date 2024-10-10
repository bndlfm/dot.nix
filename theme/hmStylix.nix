{ pkgs, ... }:{
  stylix = {
    autoEnable = false;

    image = ./wallpapers/eve-blue-girl.jpg;
    #base16Scheme = ./nord.yaml;
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
      bat.enable = true;
      bspwm.enable = true;
      btop.enable = true;
      dunst.enable = true;
      firefox.enable = true;
      fish.enable = true;
      fzf.enable = true;
      gtk.enable = true;
      hyprland.enable = true;
      kitty.enable = true;
      lazygit.enable = true;
      qutebrowser.enable = true;
      rofi.enable = true;
      swaylock = {
        enable = true;
        useImage = false;
      };
      vim.enable = false;
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
