{ config, pkgs, ... }:{
  sops.secrets = {
    "ai_keys/GROQ_SECRET_KEY" = { };
    "ai_keys/GEMINI_SECRET_KEY" = { };
  };

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
        map kitty_mod+y  launch --allow-remote-control --location=hsplit --stdin-add-formatting --stdin-source=@screen_scrollback ~/.config/kitty/smartYank.sh @active-kitty-window-id

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

        # Window / tab detach / attach (chords)
        map kitty_mod+d>p detach_window
        map kitty_mod+d>t detach_tab
        map kitty_mod+a>t attach_tab
        map kitty_mod+a>p attach_window

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


        # Base16 Nord - kitty color config
        # Scheme by arcticicestudio
        background #2E3440
        foreground #E5E9F0
        selection_background #E5E9F0
        selection_foreground #2E3440
        url_color #D8DEE9
        cursor #E5E9F0
        active_border_color #4C566A
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
    '';
  };

  xdg.configFile = {
    "kitty/smartYank.sh" = {
      # Ensure tools like curl, jq, fzf, sed, tail are in PATH.
      # pkgs.writeShellScriptBin could also be used to wrap with specific package dependencies if needed.
      source = pkgs.writeShellScript "smartYank.sh" ''
        #!/usr/bin/env bash
        export PATH = "${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.jq pkgs.curl pkgs.fzf pkgs.gnused pkgs.wl-clipboard ]}:$PATH"
        set -euo pipefail # Exit on error, undefined variable, or pipe failure

        #############################
        #   SMART YANK: Smart copy  #
        # targets from kitty screen #
        #  using LLM / fzf in bash  #
        #############################

        #########################
        # --- Configuration --- #
        #########################

        # Select API Provider: "groq" or "google".
        # Override with SMARTYANK_API_PROVIDER environment variable.
        # Example: export SMARTYANK_API_PROVIDER="google"
        # Defaulting to "groq" if SMARTYANK_API_PROVIDER is not set or empty.
        API_PROVIDER="''${SMARTYANK_API_PROVIDER:-google}"

        # Groq Configuration (used if API_PROVIDER is "groq")
        GROQ_API_ENDPOINT="https://api.groq.com/openai/v1/chat/completions"
        GROQ_MODEL="''${SMARTYANK_GROQ_MODEL:-llama3-70b-8192}" # Or your preferred Groq model
        # The following line will embed the content of the secret file directly into the script.
        # Ensure this Sops path is correct in your Nix configuration.
        GROQ_API_KEY="$(cat ${config.sops.secrets."ai_keys/GROQ_SECRET_KEY".path})"

        # Google Gemini Configuration (used if API_PROVIDER is "google")
        # The actual API endpoint for Google is constructed later as it includes the API key and model.
        GOOGLE_MODEL="''${SMARTYANK_GOOGLE_MODEL:-gemini-2.5-flash-preview-05-20}" # Or your preferred Gemini model (e.g., gemini-pro)
        # Ensure this Sops path is correct in your Nix configuration if using Google.
        GOOGLE_API_KEY="$(cat ${config.sops.secrets."ai_keys/GEMINI_SECRET_KEY".path})"

        # Active configuration variables (will be set based on API_PROVIDER)
        CURRENT_API_ENDPOINT=""
        CURRENT_MODEL=""
        CURRENT_API_KEY=""
        CURRENT_API_PROVIDER_NAME=""


        #####################################
        # --- Script Initialization --- #
        #####################################

        # Determine API Provider and Set Configuration
        if [[ "$API_PROVIDER" == "google" ]]; then
          echo "SmartYank: Using Google Gemini API" >&2
          CURRENT_API_PROVIDER_NAME="Google Gemini"
          if [ -z "$GOOGLE_API_KEY" ]; then
            echo "Error: GOOGLE_API_KEY is empty or not configured." >&2
            echo "Please ensure config.sops.secrets.GEMINI_SECRET_KEY.path points to a valid, non-empty API key file." >&2
            exit 1
          fi
          CURRENT_MODEL="$GOOGLE_MODEL"
          CURRENT_API_KEY="$GOOGLE_API_KEY"
          CURRENT_API_ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/''${CURRENT_MODEL}:generateContent?key=''${CURRENT_API_KEY}"

        elif [[ "$API_PROVIDER" == "groq" ]]; then
          echo "SmartYank: Using Groq API" >&2
          CURRENT_API_PROVIDER_NAME="Groq"
          if [ -z "$GROQ_API_KEY" ]; then
            echo "Error: GROQ_API_KEY is empty or not configured." >&2
            echo "Please ensure config.sops.secrets.GROQ_SECRET_KEY.path points to a valid, non-empty API key file." >&2
            exit 1
          fi
          CURRENT_API_ENDPOINT="$GROQ_API_ENDPOINT"
          CURRENT_MODEL="$GROQ_MODEL"
          CURRENT_API_KEY="$GROQ_API_KEY"
        else
          echo "Error: Invalid API_PROVIDER specified: '$API_PROVIDER'." >&2
          echo "Set SMARTYANK_API_PROVIDER environment variable to 'groq' or 'google'." >&2
          exit 1
        fi

        echo "SmartYank: Using Model: $CURRENT_MODEL for $CURRENT_API_PROVIDER_NAME" >&2

        ########################
        # --- Script Start --- #
        ########################

        ### 1. Read screen content from stdin and remove ansi codes with sed ###
        # Takes last 100 lines. Adjust as needed.
        SCREEN_CONTENT=$(cat - | tail -n 100 | sed -r 's/\x1B\[([0-9]{1,3}(;[0-9]{1,3})*)?[mGKH]//g')

        # Define the core prompt. This might need adjustment depending on the model's behavior.
        # Note: The numbering in the prompt had a typo (5 instead of 4). Corrected it.
        PROMPT_PREFIX="${
          ''Based upon the data provided under Screen Content identify any possible copy targets for the user. URLS, COMMANDS, THE RESULT OF COMMANDS (COMMAND OUTPUT), ETC.
              1. If you choose a command as a possible copy target suggest possible arguments, JUST THE COMMAND ITSELF IS NOT USEFUL.
              2. Use the most recent commands to try and identify relevance of copy targets.
              3. RETURN ONLY COPY TARGETS OR YOU WILL BREAK THE STRING, DO NOT NUMBER THE LIST.
              4. DO NOT RETURN THE SAME TARGET MULTIPLE TIMES. IF YOU CANNOT FIND THE NUMBER OF COPY TARGETS REQUESTED RETURN AS MANY AS YOU CAN.
              5. Invert the list so the most promising candidate is the last you return.
              6. Return 20 possible copy targets.

          Screen Content:

          ''}"

        if [ -z "$SCREEN_CONTENT" ]; then
          echo "Error: No screen content received from stdin." >&2
          exit 1
        fi

        ### 2. Construct Prompt and JSON Payload ###
        PROMPT="''${PROMPT_PREFIX}''${SCREEN_CONTENT}"
        JSON_PAYLOAD=""
        CURL_COMMAND_ARGS=() # Array to build curl command arguments

        if [[ "$API_PROVIDER" == "google" ]]; then
          JSON_PAYLOAD="${
            ''
              {
                "contents": [
                  {
                    "parts": [
                      {
                        "text": ''$(jq -sRc '.' <<< "''$PROMPT") # Note the escaping for shell
                      }
                    ]
                  }
                ],
                "generationConfig": {
                  "maxOutputTokens": 1500
                }
              }
            ''
          }"
          CURL_COMMAND_ARGS=(
            -s -X POST
            -H 'Content-Type: application/json'
            --data "$JSON_PAYLOAD"
            "$CURRENT_API_ENDPOINT"
          )
        elif [[ "$API_PROVIDER" == "groq" ]]; then
          JSON_PAYLOAD="${
            ''
              {
                "model": "''${CURRENT_MODEL}",
                "messages": [{
                  "role": "user",
                  "content": ''$(jq -sRc '.' <<< "''$PROMPT")
                }],
                "max_tokens": 1500
              }
            ''
          }"
          CURL_COMMAND_ARGS=(
            -s -X POST
            -H "Authorization: Bearer ''${CURRENT_API_KEY}"
            -H 'Content-Type: application/json'
            --data "$JSON_PAYLOAD"
            "$CURRENT_API_ENDPOINT"
          )
        fi

        # For debugging the payload:
        # echo "JSON Payload:" >&2
        # echo "$JSON_PAYLOAD" >&2
        # echo "Curl command: curl ''${CURL_COMMAND_ARGS[@]}" >&2

        ### 3. Call LLM API using curl ###
        LLM_RESPONSE=$(curl "''${CURL_COMMAND_ARGS[@]}")

        if [ -z "$LLM_RESPONSE" ]; then
          echo "Error: Empty response from $CURRENT_API_PROVIDER_NAME API." >&2
          exit 1
        fi

        ### 4. Extract copy targets from LLM response using jq ###
        COPY_TARGETS=""
        if [[ "$API_PROVIDER" == "google" ]]; then
          # Check for errors in Google response first
          if echo "$LLM_RESPONSE" | jq -e '.error' > /dev/null; then
            ERROR_MESSAGE=$(echo "$LLM_RESPONSE" | jq -r '.error.message')
            echo "Error from Google API: $ERROR_MESSAGE" >&2
            echo "Full Google API response: $LLM_RESPONSE" >&2
            exit 1
          fi
          # Check if candidates array exists and has content
          if ! echo "$LLM_RESPONSE" | jq -e '.candidates[0].content.parts[0].text' > /dev/null 2>&1; then
              echo "Error: Unexpected response structure from Google API or no content." >&2
              echo "Google API Response: $LLM_RESPONSE" >&2
              exit 1
          fi
          COPY_TARGETS=$(echo "$LLM_RESPONSE" | jq -r '.candidates[0].content.parts[0].text')
        elif [[ "$API_PROVIDER" == "groq" ]]; then
          # Check for errors in Groq response
          if echo "$LLM_RESPONSE" | jq -e '.error' > /dev/null; then
            ERROR_MESSAGE=$(echo "$LLM_RESPONSE" | jq -r '.error.message')
            echo "Error from Groq API: $ERROR_MESSAGE" >&2
            echo "Full Groq API response: $LLM_RESPONSE" >&2
            exit 1
          fi
          # Check if choices array exists and has content
          if ! echo "$LLM_RESPONSE" | jq -e '.choices[0].message.content' > /dev/null 2>&1; then
              echo "Error: Unexpected response structure from Groq API or no content." >&2
              echo "Groq API Response: $LLM_RESPONSE" >&2
              exit 1
          fi
          COPY_TARGETS=$(echo "$LLM_RESPONSE" | jq -r '.choices[0].message.content')
        fi

        if [ -z "$COPY_TARGETS" ] || [ "$COPY_TARGETS" == "null" ]; then
          echo "No copy targets found in LLM response or response was null." >&2
          echo "LLM Raw Response for $CURRENT_API_PROVIDER_NAME: $LLM_RESPONSE" >&2
          exit 1
        fi

        ### 5. Select copy target using fzf ###
        # --no-sort because the LLM is asked to invert the list (most promising last)
        # --reverse makes fzf display items bottom-up, so last item (most promising) is at the top
        SELECTED_TARGET=$(echo -e "$COPY_TARGETS" | fzf --no-sort --reverse)

        if [ -z "$SELECTED_TARGET" ]; then
          echo "No item selected in fzf. Aborting." >&2
          exit 0 # User cancelled fzf, not an error
        fi

        ### 6. Copy to clipboard (wl-copy, xclip, clip.exe for WSL) ###
        if command -v wl-copy >/dev/null 2>&1; then
          echo -n "$SELECTED_TARGET" | wl-copy
          echo "Copied to Wayland clipboard." >&2
        elif command -v xclip >/dev/null 2>&1; then
          echo -n "$SELECTED_TARGET" | xclip -i -selection clipboard
          echo "Copied to X11 clipboard." >&2
        elif command -v clip.exe >/dev/null 2>&1; then # For WSL
          echo -n "$SELECTED_TARGET" | clip.exe
          echo "Copied to Windows clipboard via clip.exe." >&2
        else
          echo "Warning: No clipboard tool (wl-copy, xclip, clip.exe) found. Printing to stdout:" >&2
          echo "$SELECTED_TARGET"
          # sleep 1 # Optional: allow user to see the message
          exit 0
        fi

        exit 0
      ''; # End of writeShellScript
    };
  };
}
