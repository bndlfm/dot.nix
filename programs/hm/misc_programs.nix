{ pkgs, ... }:{

  programs = {
    bash = {
      #bashrcExtra = "exec fish";
      initExtra ="[[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != 'fish' && -z \${BASH_EXECUTION_STRING} ]] && exec ${pkgs.fish}/bin/fish";
    };
    broot = {
      enable = true;
      enableFishIntegration = true;
    };
    carapace = {
      enable = true;
      enableFishIntegration = true;
    };
    dircolors = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
