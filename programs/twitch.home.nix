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
      "~/.config/twt/config.toml" = {
        source = pkgs.writeText "config.toml" ''
          [twitch]
          username = "mamimi___"
          channel = "mamimi___"
          server = "irc.chat.twitch.tv"
          token = ""

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
          favorite_channels = [ "tomato", "meat", "beribug", "grimmiVT", "strippin" ]
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
