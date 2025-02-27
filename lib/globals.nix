# lib/globals.nix
{
  # monitor info for tiling wm and etc
  monitors =
    {
      left =
        {
          output = "HDMI-A-1";
          pos =
            {
              x = "0";
              y = "0";
            };
          resolution =
            {
              width = 1920;
              height = 1200;
            };
          rate = 60;
        };

      center =
        {
          output = "DP-1";
          pos =
            {
              x = "1200";
              y = "0";
            };
          resolution =
            {
              width = 2560;
              height = 1440;
            };
          rate = 144;
        };

      right =
        {
          output = "HDMI-A-3";
          pos =
            {
              x = "3760";
              y = "0";
            };
          resolution =
            {
              width = 1920;
              height = 1200;
            };
          rate = 60;
        };
    };
}
