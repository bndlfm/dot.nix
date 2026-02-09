{ config, pkgs, ... }:
let
  smartYankScript = import ./kitty.smartYank.nix { inherit config pkgs; };
  selectWindowAttachTab = import ./kitty.attachWindowToCurrentTab.nix { inherit pkgs; };
  selectTabAttachTab = import ./kitty.attachTabToCurrentOSWindow.nix { inherit pkgs; };
in
{
  sops.secrets = {
    "ai_keys/GROQ_SECRET_KEY" = { };
    "ai_keys/GEMINI_SECRET_KEY" = { };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "InconsolataNFM-Regular";
      size = 14;
      package = pkgs.nerd-fonts.inconsolata;
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";

      "ctrl+l" = ''combine : clear_terminal scroll active : send_text normal,application \x0c'';
      "ctrl+alt+enter" = "launch --cwd=current";

      "shift+insert" = "paste_from_selection";
      "kitty_mod+s" = "paste_from_selection";
      "kitty_mod+v" = "paste_from_clipboard";
      "kitty_mod+y" =
        "launch --allow-remote-control --location=hsplit --stdin-add-formatting --stdin-source=@screen_scrollback ${smartYankScript} @active-kitty-window-id";

      "kitty_mod+page_up" = "scroll_page_up";
      "kitty_mod+page_down" = "scroll_page_down";
      "kitty_mod+home" = "scroll_home";
      "kitty_mod+end" = "scroll_end";

      "kitty_mod+1" = "first_window";
      "kitty_mod+2" = "second_window";
      "kitty_mod+3" = "third_window";
      "kitty_mod+4" = "fourth_window";
      "kitty_mod+5" = "fifth_window";
      "kitty_mod+6" = "sixth_window";
      "kitty_mod+7" = "seventh_window";
      "kitty_mod+8" = "eighth_window";
      "kitty_mod+9" = "ninth_window";
      "kitty_mod+0" = "tenth_window";

      "kitty_mod+." = "next_tab";
      "kitty_mod+," = "previous_tab";
      "kitty_mod+t" = "new_tab";
      "kitty_mod+q" = "close_tab";
      "kitty_mod+alt+." = "move_tab_forward";
      "kitty_mod+alt+," = "move_tab_backward";
      "kitty_mod+alt+t" = "set_tab_title";

      "kitty_mod+equal" = "change_font_size all +1.0";
      "kitty_mod+minus" = "change_font_size all -1.0";
      "kitty_mod+backspace" = "change_font_size all 0";

      "kitty_mod+f>p" = "kitten hints --type path --program -";
      "kitty_mod+f>c" = "kitten hints --type path --program @";
      "kitty_mod+l" = "kitten hints";
      "kitty_mod+f>o" = "kitten hints --type path";
      "kitty_mod+f>l" = "kitten hints --type line --program -";
      "kitty_mod+f>w" = "kitten hints --type word --program -";
      "kitty_mod+f>h" = "kitten hints --type hash --program -";
      "kitty_mod+f>n" = "kitten hints --type linenum";

      "kitty_mod+/" =
        "launch --allow-remote-control kitty +kitten kitty_search/search.py @active-kitty-window-id";

      "kitty_mod+a>m" = "set_background_opacity +0.1";
      "kitty_mod+a>l" = "set_background_opacity -0.1";
      "kitty_mod+a>1" = "set_background_opacity 1";
      "kitty_mod+a>d" = "set_background_opacity default";

      "kitty_mod+d>p" = "detach_window";
      "kitty_mod+d>t" = "detach_tab";
      "kitty_mod+a>t" = "remote_control_script ${selectTabAttachTab}";
      "kitty_mod+a>p" = "remote_control_script ${selectWindowAttachTab}";

      "kitty_mod+b" = "launch --location=hsplit";
      "kitty_mod+o" = "launch --location=vsplit";
      "kitty_mod+j" = "layout_action rotate";

      "shift+up" = "move_window up";
      "shift+left" = "move_window left";
      "shift+right" = "move_window right";
      "shift+down" = "move_window down";

      "kitty_mod+h" = "neighboring_window left";
      "kitty_mod+n" = "neighboring_window down";
      "kitty_mod+e" = "neighboring_window up";
      "kitty_mod+i" = "neighboring_window right";

      "kitty_mod+f9" = "clear_terminal reset active";
      "kitty_mod+f10" = "clear_terminal clear active";
      "kitty_mod+f11" = "clear_terminal scrollback active";
      "kitty_mod+f12" = "clear_terminal scroll active";
      "kitty_mod+delete" = "clear_terminal reset active";

      "ctrl+h" = "kitty_scrollback_nvim";
      "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
    };
    extraConfig = /* bash */ ''
      scrollback_lines 100000

      allow_remote_control yes
      linux_display_server auto
      placement_strategy center
      mouse_hide_wait 0
      sync_to_monitor yes

      listen_on unix:/tmp/kitty

      copy_on_select yes
      clipboard_control write-clipboard write-primary read-clipboard read-primary no-append

      ###########
      # ALIASES #
      ###########
        kitten_alias hints hints --hints-offset=0

        # Set alias for kitty_scrollback_nvim
        action_alias kitty_scrollback_nvim kitten /home/neko/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py

        # Show clicked command output in nvim
        mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output

      ########
      # BELL #
      ########
        enable_audio_bell yes
        window_alert_on_bell yes
        bell_on_tab yes

      ##############
      # FISH FIXES #
      ##############
        #: To fix Fish Vi keys
        shell_integration no-cursor
        shell fish

      #########
      # THEME #
      #########
        #--- COLOR SCHEME ---#
          # Base16 Nord - kitty color config
          # Scheme by arcticicestudio
          background #2E3440
          foreground #E5E9F0
          selection_background #E5E9F0
          selection_foreground #2E3440
          url_color #D8DEE9
          cursor #E5E9F0
          active_border_color #C0C8D8
          inactive_border_color #3B4252
          active_tab_background #2E3440
          active_tab_foreground #E5E9F0
          inactive_tab_background #3B4252
          inactive_tab_foreground #D8DEE9
          tab_bar_background #3B4252

          # normal
          color0 #2E3440
          color1 #BF616A
          color2 #A3BE8C
          color3 #EBCB8B
          color4 #81A1C1
          color5 #B48EAD
          color6 #88C0D0
          color7 #E5E9F0

          # bright
          color8 #4C566A
          color9 #D08770
          color10 #3B4252
          color11 #434C5E
          color12 #D8DEE9
          color13 #ECEFF4
          color14 #5E81AC
          color15 #8FBCBB

        #--- FONTS ---#
          #font_family      InconsolataNFM-Regular
          bold_font        InconsolataNFM-Bold
          italic_font      TerminessNF
          bold_italic_font TerminessNF-Bold

          font_size 14.0

        #--- MISC APPEARANCE ---#
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
    '';
    shellIntegration = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
