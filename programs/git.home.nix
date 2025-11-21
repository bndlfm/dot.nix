{ ... }:{
  programs =
    {
      delta.enableGitIntegration = true;
      git =
        {
          settings =
            {
              userEmail = "firefliesandlightningbugs@gmail.com";
              userName = "bndlfm";
              gpg.format = "ssh";
              credentialHelper = "oauth";
            };
          signing =
            {
              key = "/home/neko/.ssh/github";
              signByDefault = true;
            };
          lfs.enable = true;
        };
      gh =
        {
          enable = true;
          gitCredentialHelper.enable = true;
        };
    };
}
