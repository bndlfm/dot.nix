{ inputs, pkgs, ... }:{
  services.sunshine = {
    enable = true;
    package = pkgs.sunshine;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
