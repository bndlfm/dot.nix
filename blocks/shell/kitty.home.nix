{ config, pkgs, ... }:
let
  smartYankScript = pkgs.writeScript "smart-yank" /* fish */ ''
    #!${pkgs.fish}/bin/fish

    # SmartYank — LLM-powered copy target picker for Kitty terminal.
    # Reads scrollback from stdin, asks an LLM to identify useful copy targets,
    # and presents them via fzf for selection → clipboard.

    # ── Dependencies ─────────────────────────────────────────────────────────────
    set -x PATH (string split : "${
      pkgs.lib.makeBinPath [
        pkgs.coreutils
        pkgs.jq
        pkgs.curl
        pkgs.fzf
        pkgs.gnused
        pkgs.wl-clipboard
      ]
    }") $PATH

    # ── Capture stdin immediately ──────────────────────────────────────────────
    # fish 3.4+ redirects stdin to /dev/null inside command substitutions,
    # so we must slurp it here at the top level via the `read` builtin.
    read -z _raw_stdin

    # ── Provider Configuration ─────────────────────────────────────────────────
    set provider (set -q SMARTYANK_API_PROVIDER; and echo $SMARTYANK_API_PROVIDER; or echo google)

    switch $provider
        case google
            set model    (set -q SMARTYANK_GOOGLE_MODEL; and echo $SMARTYANK_GOOGLE_MODEL; or echo "gemini-2.5-flash-preview-05-20")
            set api_key  (cat ${config.sops.secrets."ai_keys/GEMINI_SECRET_KEY".path} | string trim)
            set provider_name "Google Gemini"
            set endpoint "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$api_key"
            set auth_header ""
            set payload_jq  '{contents: [{parts: [{text: $pt}]}], generationConfig: {maxOutputTokens: 1500}}'
            set response_jq '.candidates[0].content.parts[0].text'

        case groq
            set model    (set -q SMARTYANK_GROQ_MODEL; and echo $SMARTYANK_GROQ_MODEL; or echo "llama3-70b-8192")
            set api_key  (cat ${config.sops.secrets."ai_keys/GROQ_SECRET_KEY".path} | string trim)
            set provider_name "Groq"
            set endpoint "https://api.groq.com/openai/v1/chat/completions"
            set auth_header "Authorization: Bearer $api_key"
            set payload_jq  '{model: $model, messages: [{role: "user", content: $pt}], max_tokens: 1500}'
            set response_jq '.choices[0].message.content'

        case '*'
            echo "Error: Invalid SMARTYANK_API_PROVIDER: '$provider'. Use 'google' or 'groq'." >&2
            exit 1
    end

    if test -z "$api_key"
        echo "Error: API key for $provider_name is empty or not configured." >&2
        exit 1
    end

    echo "SmartYank: Using $provider_name — model: $model" >&2

    # ── Process Screen Content ─────────────────────────────────────────────────
    set screen_content (printf '%s' "$_raw_stdin" | tail -n 100 | sed -r 's/\x1B\[([0-9]{1,3}(;[0-9]{1,3})*)?[mGKH]//g' | string collect)

    if test -z "$screen_content"
        echo "Error: No screen content received from stdin." >&2
        exit 1
    end

    # ── Build Prompt ───────────────────────────────────────────────────────────
    set prompt "Based upon the data provided under Screen Content identify any possible copy targets for the user. URLS, COMMANDS, THE RESULT OF COMMANDS (COMMAND OUTPUT), ETC.
    1. If you choose a command as a possible copy target suggest possible arguments, JUST THE COMMAND ITSELF IS NOT USEFUL.
    2. Use the most recent commands to try and identify relevance of copy targets.
    3. RETURN ONLY COPY TARGETS OR YOU WILL BREAK THE STRING, DO NOT NUMBER THE LIST.
    4. DO NOT RETURN THE SAME TARGET MULTIPLE TIMES. IF YOU CANNOT FIND THE NUMBER OF COPY TARGETS REQUESTED RETURN AS MANY AS YOU CAN.
    5. Invert the list so the most promising candidate is the last you return.
    6. Return 20 possible copy targets.

    Screen Content:

    $screen_content"

    # ── Call LLM ───────────────────────────────────────────────────────────────
    set json_payload (jq -c -n --arg pt "$prompt" --arg model "$model" "$payload_jq")

    set curl_args -s -X POST -H 'Content-Type: application/json'
    if test -n "$auth_header"
        set -a curl_args -H "$auth_header"
    end
    set -a curl_args --data "$json_payload" "$endpoint"

    set llm_response (curl $curl_args | string collect)

    if test -z "$llm_response"
        echo "Error: Empty response from $provider_name." >&2
        exit 1
    end

    # ── Parse Response ─────────────────────────────────────────────────────────
    if echo "$llm_response" | jq -e '.error' >/dev/null 2>&1
        echo "Error from $provider_name: "(echo "$llm_response" | jq -r '.error.message') >&2
        echo "Full response: $llm_response" >&2
        exit 1
    end

    if not echo "$llm_response" | jq -e "$response_jq" >/dev/null 2>&1
        echo "Error: Unexpected response structure from $provider_name." >&2
        echo "Response: $llm_response" >&2
        exit 1
    end

    set copy_targets (echo "$llm_response" | jq -r "$response_jq" | string collect)

    if test -z "$copy_targets"; or test "$copy_targets" = null
        echo "No copy targets found in $provider_name response." >&2
        echo "Raw response: $llm_response" >&2
        exit 1
    end

    # ── Select via fzf ────────────────────────────────────────────────────────
    set selected (echo "$copy_targets" | fzf --no-sort --reverse | string collect)

    if test -z "$selected"
        echo "No item selected. Aborting." >&2
        exit 0
    end

    # ── Copy to Clipboard ─────────────────────────────────────────────────────
    if type -q wl-copy
        echo -n "$selected" | wl-copy
        echo "Copied to Wayland clipboard." >&2
    else if type -q xclip
        echo -n "$selected" | xclip -i -selection clipboard
        echo "Copied to X11 clipboard." >&2
    else if type -q clip.exe
        echo -n "$selected" | clip.exe
        echo "Copied to Windows clipboard via clip.exe." >&2
    else
        echo "Warning: No clipboard tool found. Printing to stdout:" >&2
        echo "$selected"
    end
  '';
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
      "kitty_mod+f>h" =
        "kitten hints --type regex --regex '(?i)\\b([0-9a-f]{7,128}|sha256-[A-Za-z0-9+/=]+|[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})\\b' --program -";
      "kitty_mod+f>n" = "kitten hints --type linenum";

      "kitty_mod+/" =
        "launch --allow-remote-control kitty +kitten kitty_search/search.py @active-kitty-window-id";

      "kitty_mod+a>m" = "set_background_opacity +0.1";

      "kitty_mod+a>l" = "set_background_opacity -0.1";
      "kitty_mod+a>1" = "set_background_opacity 1";
      "kitty_mod+a>d" = "set_background_opacity default";

      "kitty_mod+d>p" = "detach_window";
      "kitty_mod+d>t" = "detach_tab";
      "kitty_mod+a>t" = "detach_tab ask";
      "kitty_mod+a>p" = "detach_window ask";

      "kitty_mod+|" = "launch --location=hsplit";
      "kitty_mod+b" = "launch --location=vsplit";
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
          background_opacity 0.9
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
          font_family      InconsolataNFM-Regular
          bold_font        InconsolataNFM-Bold
          italic_font      TerminessNF
          bold_italic_font TerminessNF-Bold

          font_size 16.0

        #--- MISC APPEARANCE ---#
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

          # FIXES ROUNDED CORNERS CLIPPING
          window_margin_width 0 1
          window_padding_width 0
          window_border_width 2
    '';
    shellIntegration = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
