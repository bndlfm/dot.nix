{ pkgs, ...}:{
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.stable.ncmpcpp;
    bindings = [
      { key = "h"; command = "previous_column"; }
      { key = "n"; command = "scroll_down"; }
      { key = "e"; command = "scroll_up"; }
      { key = "i"; command = "next_column"; }
      { key = "."; command = "next_found_item"; }
      { key = ","; command = "previous_found_item"; }
      { key = "h"; command = "volume_down"; }
      { key = "i"; command = "volume_up"; }
      { key = "H"; command = "seek_backward"; }
      { key = "I"; command = "seek_forward"; }
      { key = "g"; command = "move_home"; }
      { key = "G"; command = "move_end"; }
      { key = "w"; command = "scroll_down_album"; }
      { key = "b"; command = "scroll_up_album"; }
      { key = "N"; command = "move_selected_items_down"; }
      { key = "E"; command = "move_selected_items_up"; }
      { key = "K"; command = "edit_song"; }
      { key = "?"; command = "show_help"; }
      { key = "S"; command = "show_song_info"; }
      { key = "a"; command = "show_artist_info"; }
      { key = "ctrl-l"; command = "update_database"; }
      { key = "t"; command = "execute_command"; }
      { key = "s"; command = "save_playlist"; }
      ];
    settings = {
      ncmpcpp_directory = "~/.config/ncmpcpp";
      mpd_host = "localhost";
      mpd_port = 6600;
      mpd_connection_timeout = 5;
      #mpd_music_dir = "~/Music";
      mpd_crossfade_time = 0;
      visualizer_in_stereo = true;
      visualizer_type = "wave_filled";
      visualizer_look = "▋▋";
      visualizer_color = "blue, cyan, green, yellow, magenta, red";
      playlist_disable_highlight_delay = 0;
      message_delay_time = 1;
      song_list_format = " $0%n $1• $8%t $R$0%a ";
      song_status_format = " $3%t $0 $1%a ";
      song_library_format = "{%n - }{%t}|{%f}";
      alternative_header_first_line_format = "$b$1$aqqu$/a$9 {%t}|{%f} $1$atqq$/a$9$/b";
      alternative_header_second_line_format = "{{$4$b%a$/b$9}{ - $7%b$9}{ ($4%y$9)}}|{%D}";
      current_item_prefix = "$(blue)$r";
      current_item_suffix = "$/r$(end)";
      current_item_inactive_column_prefix = "$(white)$r";
      current_item_inactive_column_suffix = "$/r$(end)";
      now_playing_prefix = "$b$2 喇 $8";
      now_playing_suffix = "$8$/b";
      browser_playlist_prefix = "$2 ♥ $0 ";
      selected_item_prefix = "$6";
      selected_item_suffix = "$9";
      modified_item_prefix = "$3> $9";
      song_window_title_format = "%t  %b";
      browser_sort_mode = "mtime";
      browser_sort_format = "{%a - }{%t}|{%f} {(%l)}";
      song_columns_list_format = "(36)[white]{t|f:Title}(28f)[white]{}";
      execute_on_song_change = "";
      execute_on_player_state_change = "";
      playlist_show_mpd_host = false;
      playlist_show_remaining_time = false;
      playlist_shorten_total_times = false;
      playlist_separate_albums = true;
      playlist_display_mode = "columns";
      browser_display_mode = "classic";
      search_engine_display_mode = "classic";
      playlist_editor_display_mode = "classic";
      discard_colors_if_item_is_selected = true;
      show_duplicate_tags = true;
      incremental_seeking = true;
      seek_time = 1;
      volume_change_step = 2;
      autocenter_mode = true;
      centered_cursor = false;
      progressbar_look = "▃▃▃";
      default_place_to_search_in = "database";
      user_interface = "classic";
      data_fetching_delay = true;
      media_library_primary_tag = "album_artist";
      media_library_albums_split_by_date = true;
      default_find_mode = "wrapped";
      default_tag_editor_pattern = "%n - %t";
      header_visibility = false;
      statusbar_visibility = false;
      titles_visibility = false;
      header_text_scrolling = true;
      cyclic_scrolling = false;
      lines_scrolled = 2;
      follow_now_playing_lyrics = false;
      fetch_lyrics_for_current_song_in_background = true;
      store_lyrics_in_song_dir = true;
      generate_win32_compatible_filenames = true;
      allow_for_physical_item_deletion = false;
      lastfm_preferred_language = "en";
      space_add_mode = "add_remove";
      show_hidden_files_in_local_browser = false;
      screen_switcher_mode = "playlist, media_library";
      startup_screen = "playlist";
      startup_slave_screen_focus = false;
      locked_screen_width_part = 50;
      ask_for_locked_screen_width_part = true;
      jump_to_now_playing_song_at_start = true;
      ask_before_clearing_playlists = false;
      clock_display_seconds = false;
      display_volume_level = true;
      display_bitrate = false;
      display_remaining_time = false;
      regular_expressions = "perl";
      ignore_leading_the = false;
      ignore_diacritics = true;
      block_search_constraints_change_if_items_found = true;
      mouse_support = true;
      mouse_list_scroll_whole_page = true;
      empty_tag_marker = " -- ‼ -- ";
      tags_separator = " | ";
      tag_editor_extended_numeration = false;
      media_library_sort_by_mtime = false;
      enable_window_title = true;
      search_engine_default_search_mode = 1;
      external_editor = "nvim";
      use_console_editor = true;
      colors_enabled = true;
      empty_tag_color = "red";
      header_window_color = "red";
      volume_color = "default";
      state_line_color = "black";
      state_flags_color = "green:b";
      main_window_color = "green";
      color1 = "white";
      color2 = "green";
      progressbar_color = "black:b";
      progressbar_elapsed_color = "red:b";
      statusbar_color = "default";
      statusbar_time_color = "default:b";
      player_state_color = "default:b";
      alternative_ui_separator_color = "black:b";
      window_border_color = "green";
      active_window_border = "red";
    };
  };
}
