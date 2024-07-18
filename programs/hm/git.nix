{ pkgs, ...}:{
programs.git = {
    userName = "bndlfm";
    userEmail = "firefliesandlightningbugs@gmail.com";
    extraConfig = {
      credential.helper = "${pkgs.git-credential-gopass}/bin/git-credential-manager";
    };
  };
}
