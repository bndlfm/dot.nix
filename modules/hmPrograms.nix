{ pkgs, ... }:{

  imports = [
    ./fish.nix
    ./kitty.nix
    ./ncmpcpp.nix
    ./neovim.nix
    ./yazi.nix
  ];

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
    firefox = {
      enable = true;
      nativeMessagingHosts = [
        pkgs.tridactyl-native
      ];
      package = pkgs.firefox-devedition;
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    git = {
      userName = "bndlfm";
      userEmail = "firefliesandlightningbugs@gmail.com";
      extraConfig = {
        credential = {
          credentialStore = "secretservice";
          helper = "${pkgs.git-credential-gopass}/bin/git-credential-manager";
        };
      };
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
