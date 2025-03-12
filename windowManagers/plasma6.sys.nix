{ pkgs, ... }:{
  environment.etc."/xdg/menus/plasma-applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
