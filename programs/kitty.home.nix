{ config, ... }:{
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
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


      placement_strategy center

      linux_display_server auto
      shell fish

      #: To fix Fish Vi keys
      shell_integration no-cursor

      allow_remote_control yes
      listen_on unix:/tmp/kitty

      clipboard_control write-clipboard write-primary read-clipboard read-primary no-append

      kitten_alias hints hints --hints-offset=0


      ###############
      # KEYBINDINGS #
      ###############
        map ctrl+c copy_or_interrupt

        map kitty_mod+v  paste_from_clipboard
        map kitty_mod+s  paste_from_selection
        map shift+insert paste_from_selection
        #map kitty_mod+o  pass_selection_to_program
        map kitty_mod+y kitten smartYank.py --api-key "${builtins.readFile config.sops.secrets.GROQ_SECRET_KEY.path}"
        # --api-endpoint "https://api.groq.com/openai/v1/chat/completions" --model "llama-3.3-70b-versatile"

        map kitty_mod+up        scroll_line_up
        map kitty_mod+down      scroll_line_down
        map kitty_mod+page_up   scroll_page_up
        map kitty_mod+page_down scroll_page_down
        map kitty_mod+home      scroll_home
        map kitty_mod+end       scroll_end

        map ctrl+alt+enter    launch --cwd=current

        #: Switch Tabs
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

        # Kitten Hints
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

        # Change opacity on the fly
        map kitty_mod+a>m    set_background_opacity +0.1
        map kitty_mod+a>l    set_background_opacity -0.1
        map kitty_mod+a>1    set_background_opacity 1
        map kitty_mod+a>d    set_background_opacity default

        # Tab detach / attach
        map kitty_mod+d detach_tab ask
        map kitty_mod+a attach_tab ask

        # Pane / Split Keybinds
        map kitty_mod+b launch --location=hsplit
        map kitty_mod+o launch --location=vsplit
        map kitty_mod+j layout_action rotate
  
        # Move Panes
        map shift+up move_window up
        map shift+left move_window left
        map shift+right move_window right
        map shift+down move_window down

        # Switch Focus to Pane
        map kitty_mod+left neighboring_window left
        map kitty_mod+right neighboring_window right
        map kitty_mod+up neighboring_window up
        map kitty_mod+down neighboring_window down

        # Clear Terminal
        map kitty_mod+f9 clear_terminal reset active
        map kitty_mod+f10 clear_terminal clear active
        map kitty_mod+f11 clear_terminal scrollback active
        map kitty_mod+f12 clear_terminal scroll active

        map kitty_mod+delete clear_terminal reset active

        map ctrl+l combine : clear_terminal scroll active : send_text normal,application \x0c


      #########################
      # kitty-scrollback.nvim #
      #########################
        # Set alias for kitty_scrollback_nvim
        action_alias kitty_scrollback_nvim kitten /home/neko/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py

        # Browse scrollback buffer in nvim
        map ctrl+h kitty_scrollback_nvim

        # Browse output of the last shell command in nvim
        map kitty_mod+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output

        # Show clicked command output in nvim
        mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output


      ##############
      # APPEARANCE #
      ##############
        background_opacity 1
        dynamic_background_opacity yes
        hide_window_decorations yes

        # Tab Theming
        tab_bar_edge top
        tab_bar_min_tabs 2
        tab_fade 0.25 0.5 0.75 1

        tab_separator "|"
        tab_title_template " {index}: {title} "

        active_tab_title_template " {index}: {title} "
        active_tab_font_style    bold
        inactive_tab_font_style  italic

        # Window Pane Theming
        draw_minimal_borders yes
        single_window_margin_width -1000.0
        window_padding_width 0.0
        window_margin_width 1

        # Window Pane Borders
        window_border_width 2
        active_border_color #ffbf00
        inactive_border_color #4C566A
    '';
  };
}
