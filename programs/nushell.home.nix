{ pkgs, config, ... }:{
  programs = {
    nushell = {
      enable = true;
    };
    oh-my-posh.enableNushellIntegration = true;
    zoxide.enableNushellIntegration = true;
    yazi.enableNushellIntegration = true;
  };
}
