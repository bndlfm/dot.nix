{ ... }:{
  programs =
    {
      git =
        {
          userName = "bndlfm";
          userEmail = "firefliesandlightningbugs@gmail.com";
          delta.enable = true;
          signing =
            {
              key = "/home/neko/.ssh/github";
              signByDefault = true;
            };
          lfs.enable = true;
          extraConfig =
            {
              gpg.format = "ssh";
              credentialHelper = "oauth";
            };
        };
      gh =
        {
          enable = true;
          gitCredentialHelper.enable = true;
        };
    };
}
