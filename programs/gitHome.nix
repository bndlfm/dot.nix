{ pkgs, ... }:{
  programs = {
    git = {
      userName = "bndlfm";
      userEmail = "firefliesandlightningbugs@gmail.com";
      delta.enable = true;
      extraConfig = {
        credential.helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        #credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      };
      lfs.enable = true;
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
