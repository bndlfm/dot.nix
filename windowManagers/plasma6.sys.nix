{ pkgs, ... }:{
  environment.packages = with pkgs; [
    kdePackages.plasma-workspace
  ];
}
