{ ... }:{
  services =
    {
      arrpc.enable = true;
      kdeconnect =
        {
          enable = true;
          indicator = true;
        };
      mpd =
        let
          homeDir = builtins.getEnv "HOME";
        in
          {
            enable = true;
            musicDirectory = "${homeDir}/Music";
            network =
              {
                startWhenNeeded = true;
                port = 6600;
              };
          };
      mpdris2 =
        {
          enable = true;
          mpd = {};
          multimediaKeys = true;
          notifications = true;
        };
      mpd-discord-rpc.enable = true;
    };
}
