{  niri, ... }@inputs:{
  # Enable overlays for Niri

  # Enable and set the package for Niri
  #programs.niri = {
  #  enabled = true;
  #  package = pkgs.niri-unstable;
  #};
  #
  # Configure Niri for the user "neko"
      # Enable Niri for this user
      programs.niri = {
        enable = true;

        # Set Niri settings for this user
        settings = {
          # Set Niri layout settings
          layout = {
            gaps = 10;
            struts = {
              left = 64;
              right = 64;
              border.width = 5;
            };
          };

        # Set Niri appearance settings
        appearance = {
          # You can find a complete list of available settings here:
          # https://github.com/sodiboo/niri/blob/master/doc/configuration.md#appearance
          # ... more appearance settings
        };

        # Set Niri key bindings
        bindings = {
          # You can find a complete list of available settings here:
          # https://github.com/sodiboo/niri/blob/master/doc/configuration.md#keybindings
          # ... key bindings
        };

        # Set Niri workspaces
        workspaces = {
          # You can find a complete list of available settings here:
          # https://github.com/sodiboo/niri/blob/master/doc/configuration.md#workspaces
          # ... workspace settings
        };

        # Set Niri tiling settings
        tiling = {
          # You can find a complete list of available settings here:
          # https://github.com/sodiboo/niri/blob/master/doc/configuration.md#tiling
          # ... tiling settings
        };

        # Set Niri floating settings
        floating = {
          # You can find a complete list of available settings here:
          # https://github.com/sodiboo/niri/blob/master/doc/configuration.md#floating
          # ... floating settings
        };

        # Set Niri other settings
        # ... other settings
      };
    };
}
