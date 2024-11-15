{ pkgs, ... }:{
programs.git = {
    userName = "bndlfm";
    userEmail = "firefliesandlightningbugs@gmail.com";
    extraConfig = {
      credential.helper = "${pkgs.git-credential-gopass}/bin/git-credential-gopass";
      #credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
    lfs.enable = true;
  };
}
