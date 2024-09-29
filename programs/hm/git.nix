{ ... }:{
programs.git = {
    userName = "bndlfm";
    userEmail = "firefliesandlightningbugs@gmail.com";
    extraConfig = {
      credential.helper = "oauth";
    };
    lfs.enable = true;
  };
}
