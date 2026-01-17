{ config, ...}:
{
  defaultNetInterface =
    if config.networking.hostName == "meow"
    then "enp6s0"
    else "wlan0";
  environmentVars = {
    system = {
    };
    user = {
      wayland = {
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        NIXOS_OZONE_WL = 1;
      };
    };
  };
  monitors = # monitor info for tiling wm and etc
    {
      left =
        {
          output = "HDMI-A-1";
          pos =
            {
              x = "0";
              y = "0";
            };
          res =
            {
              width = "1920";
              height = "1200";
            };
          rate = "60";
        };
      center =
        {
          output = "DP-1";
          pos =
            {
              x = "1200";
              y = "100";
            };
          res =
            {
              width = "2560";
              height = "1440";
            };
          rate = "144";
        };
      right =
        {
          output = "DP-2";
          pos =
            {
              x = "3760";
              y = "0";
            };
          res =
            {
              width = "1920";
              height = "1080";
            };
          rate = "60";
        };
    };
}
