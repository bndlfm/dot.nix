{ ... }:{
  services =
    {
      arrpc.enable = false; # BINDS TO 1337, SAME AS DECKY-LOADER
      kdeconnect =
        {
          enable = true;
          indicator = true;
        };
    };
}
