{...}:{
  programs.kitty = {
    enable = true;
    shellIntegration.enableBashIntegration = true;
    shellIntegration.enableFishIntegration = true;
    extraConfig = /* fish */ ''
      font_family      InconsolataNFM-Regular
      bold_font        InconsolataNFM-Bold
      italic_font      TerminessNF
      bold_italic_font TerminessNF-Bold


      font_size 14.0

      scrollback_lines 100000

      mouse_hide_wait 0

      copy_on_select yes

      sync_to_monitor yes

      enable_audio_bell yes
      window_alert_on_bell yes
      bell_on_tab yes

      window_border_width 0.0

      draw_minimal_borders yes

      single_window_margin_width -1000.0

      window_padding_width 0.0

      placement_strategy center

      hide_window_decorations yes

      tab_bar_edge top
      #tab_bar_style custom
      tab_bar_min_tabs 2
      tab_fade 0.25 0.5 0.75 1

      tab_separator "|"
      tab_title_template " {index}: {title} "

      active_tab_title_template " {index}: {title} "
      active_tab_font_style    bold
      inactive_tab_font_style  italic

      dynamic_background_opacity yes

      shell fish

      allow_remote_control yes
      listen_on unix:/tmp/kitty

      ### kitty-scrollback.nvim Kitten alias
        action_alias kitty_scrollback_nvim kitten ~/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py

        ### Browse scrollback buffer in nvim
        map ctrl+h kitten ~/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py

        ### Browse output of the last shell command in nvim
        map kitty_mod+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
        ### Show clicked command output in nvim
        mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output

        clipboard_control write-clipboard write-primary read-clipboard read-primary no-append

      linux_display_server auto

      kitten_alias hints hints --hints-offset=0

      map ctrl+c copy_or_interrupt 

      map kitty_mod+v  paste_from_clipboard
      map kitty_mod+s  paste_from_selection
      map shift+insert paste_from_selection
      #map kitty_mod+o  pass_selection_to_program
      map kitty_mod+y new_window less @selection

      map kitty_mod+up        scroll_line_up
      map kitty_mod+down      scroll_line_down
      map kitty_mod+page_up   scroll_page_up
      map kitty_mod+page_down scroll_page_down
      map kitty_mod+home      scroll_home
      map kitty_mod+end       scroll_end
      map control+h           show_scrollback

      map ctrl+alt+enter    launch --cwd=current

      map kitty_mod+1 first_window
      map kitty_mod+2 second_window
      map kitty_mod+3 third_window
      map kitty_mod+4 fourth_window
      map kitty_mod+5 fifth_window
      map kitty_mod+6 sixth_window
      map kitty_mod+7 seventh_window
      map kitty_mod+8 eighth_window
      map kitty_mod+9 ninth_window
      map kitty_mod+0 tenth_window

      map kitty_mod+i     next_tab
      map kitty_mod+h     previous_tab
      map kitty_mod+t     new_tab
      map kitty_mod+q     close_tab
      map kitty_mod+.     move_tab_forward
      map kitty_mod+,     move_tab_backward
      map kitty_mod+alt+t set_tab_title

      map kitty_mod+equal     change_font_size all +1.0
      map kitty_mod+minus     change_font_size all -1.0
      map kitty_mod+backspace change_font_size all 0

      map kitty_mod+f>p kitten hints --type path --program -
      map kitty_mod+f>c kitten hints --type path --program @
      map kitty_mod+e kitten hints
      map kitty_mod+f>o kitten hints --type path
      map kitty_mod+f>l kitten hints --type line --program -
      map kitty_mod+f>w kitten hints --type word --program -
      map kitty_mod+f>h kitten hints --type hash --program -

      #: Select something that looks like filename:linenum and open it in
      #: vim at the specified line number.
      map kitty_mod+f>n kitten hints --type linenum

      map kitty_mod+/      launch --allow-remote-control kitty +kitten kitty_search/search.py @active-kitty-window-id
      map kitty_mod+k      kitten unicode_input

      map kitty_mod+a>m    set_background_opacity +0.1
      map kitty_mod+a>l    set_background_opacity -0.1
      map kitty_mod+a>1    set_background_opacity 1
      map kitty_mod+a>d    set_background_opacity default

      map kitty_mod+delete clear_terminal reset active

      map kitty_mod+d detach_tab ask
      map kitty_mod+a attach_tab ask
 
      ### BORDERS
        draw_minimal_borders no
        window_border_width 3
        active_border_color #00ff00
        inactive_border_color #cccccc
        map kitty_mod+b launch --location=hsplit
        map kitty_mod+o launch --location=vsplit
        map kitty_mod+j layout_action rotate

      map kitty_mod+f9 clear_terminal reset active
      map kitty_mod+f10 clear_terminal clear active
      map kitty_mod+f11 clear_terminal scrollback active
      map kitty_mod+f12 clear_terminal scroll active

      # Move the active window in the indicated direction
      map shift+up move_window up
      map shift+left move_window left
      map shift+right move_window right
      map shift+down move_window down

      # Switch focus to the neighboring window in the indicated direction
      map kitty_mod+left neighboring_window left
      map kitty_mod+right neighboring_window right
      map kitty_mod+up neighboring_window up
      map kitty_mod+down neighboring_window down

      map ctrl+l combine : clear_terminal scroll active : send_text normal,application \x0c

      # to fix fish vi keys
      shell_integration no-cursor

      # Looks
      background_opacity 1

      ### https://draculatheme.com/kitty
      ##foreground            #f8f8f2
      ##background            #282a36
      ##selection_foreground  #ffffff
      ##selection_background  #44475a

      ##url_color #8be9fd

      ### black
      ##color0  #21222c
      ##color8  #6272a4

      ### red
      ##color1  #ff5555
      ##color9  #ff6e6e

      ### green
      ##color2  #50fa7b
      ##color10 #69ff94

      ### yellow
      ##color3  #f1fa8c
      ##color11 #ffffa5

      ### blue
      ##color4  #bd93f9
      ##color12 #d6acff

      ### magenta
      ##color5  #ff79c6
      ##color13 #ff92df

      ### cyan
      ##color6  #8be9fd
      ##color14 #a4ffff

      ### white
      ##color7  #f8f8f2
      ##color15 #ffffff

      ### Cursor colors
      ##cursor            #f8f8f2
      ##cursor_text_color background

      ### Tab bar colors
      ##active_tab_foreground   #282a36
      ##active_tab_background   #f8f8f2
      ##inactive_tab_foreground #282a36
      ##inactive_tab_background #6272a4

      ### Marks
      ##mark1_foreground #282a36
      ##mark1_background #ff5555

      ### Splits/Windows
      ##active_border_color #f8f8f2
      ##inactive_border_color #6272a4
    '';
  };
}
