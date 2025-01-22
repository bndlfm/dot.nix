{ pkgs, ... }:{

  programs = {
    bash = {
      #bashrcExtra = "exec fish";
      initExtra ="[[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != 'fish' && -z \${BASH_EXECUTION_STRING} ]] && exec ${pkgs.fish}/bin/fish";
    };
    broot = {
      enable = true;
    };
    carapace = {
      enable = true;
    };
    dircolors = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
    };
    nix-index = {
      enable = true;
    };
  };
}
