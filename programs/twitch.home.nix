{
config,
pkgs,
...
}:
{
  home.packages =
    with pkgs;
    [
      mpv
      streamlink
      streamlink-twitch-gui-bin
      twitch-tui
    ];

  xdg = {
    configFile = {
      "twt/config.toml" = {
        source = pkgs.writeText "config.toml" ''
          [twitch]
          username = "mamimi___"
          channel = "mamimi___"
          server = "irc.chat.twitch.tv"
          token = "${builtins.readFile config.sops.secrets.TWITCH_IRC_OAUTH.path}"

          [terminal]
          delay = 30
          maximum_messages = 500
          verbose = false
          first_state = "Dashboard"

          [storage]
          channels = false
          mentions = false

          [filters]
          enabled = false
          reversed = false

          [frontend]
          favorite_channels = [ "vinesauce", "vargskelethor", "tomato", "meat", "margo", "beribug", "grimmi", "criken" ]
          show_datetimes = true
          datetime_format = "%a %b %e %T %Y"
          username_shown = true
          palette = "pastel"
          title_shown = true
          margin = 0
          badges = false
          theme = "dark"
          username_highlight = true
          state_tabs = false
          cursor_shape = "user"
          blinking_cursor = false
          inverted_scrolling = false
          show_scroll_offset = false
          twitch_emotes = true
          betterttv_emotes = true
          seventv_emotes = true
          frankerfacez_emotes = true
          recent_channel_count = 5
          border_type = "plain"
          hide_chat_border = false
          right_align_usernames = false
          show_unsupported_screen_size = true
        '';
      };
    };
  };
}
