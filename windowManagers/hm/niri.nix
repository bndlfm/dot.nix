{ niri, ... }:{
  programs.niri = {
    settings = {
      #binds = with niri.config.lib.niri.actions; let
      input = {};
      layout = {
        gaps = 10;
        struts = {
          left = 10;
          right = 10;
          top = 10;
          bottom = 10;
          };
        };
      outputs = {
        "DP-1" = {
          enable = true;
          position = {
            x = 1080;
            y = 0;
          };
        };
        "DP-2" = {
          enable = true;
          position = {
            x = 3640;
            y = 0;
          };
          transform.rotation = 270;
        };
        "HDMI-A-1" = {
          enable = true;
          position = {
            x = 0;
            y = 0;
          };
          transform.rotation = 270;
        };
      };
      workspaces = {};
    };
  };
}
