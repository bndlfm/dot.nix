{ config, pkgs }:
pkgs.writeShellScript "smartYank.sh" ''
  #!/usr/bin/env bash
  export PATH="${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.jq pkgs.curl pkgs.fzf pkgs.gnused pkgs.wl-clipboard ]}:$PATH"
  set -euo pipefail

  API_PROVIDER="''${SMARTYANK_API_PROVIDER:-google}"

  GROQ_API_ENDPOINT="https://api.groq.com/openai/v1/chat/completions"
  GROQ_MODEL="''${SMARTYANK_GROQ_MODEL:-llama3-70b-8192}"
  GROQ_API_KEY="$(cat ${config.sops.secrets."ai_keys/GROQ_SECRET_KEY".path})"

  GOOGLE_MODEL="''${SMARTYANK_GOOGLE_MODEL:-gemini-2.5-flash-preview-05-20}"
  GOOGLE_API_KEY="$(cat ${config.sops.secrets."ai_keys/GEMINI_SECRET_KEY".path})"

  CURRENT_API_ENDPOINT=""
  CURRENT_MODEL=""
  CURRENT_API_KEY=""
  CURRENT_API_PROVIDER_NAME=""

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

  SCREEN_CONTENT=$(cat - | tail -n 100 | sed -r 's/\x1B\[([0-9]{1,3}(;[0-9]{1,3})*)?[mGKH]//g')

  PROMPT_PREFIX="
    Based upon the data provided under Screen Content identify any possible copy targets for the user. URLS, COMMANDS, THE RESULT OF COMMANDS (COMMAND OUTPUT), ETC.
              1. If you choose a command as a possible copy target suggest possible arguments, JUST THE COMMAND ITSELF IS NOT USEFUL.
              2. Use the most recent commands to try and identify relevance of copy targets.
              3. RETURN ONLY COPY TARGETS OR YOU WILL BREAK THE STRING, DO NOT NUMBER THE LIST.
              4. DO NOT RETURN THE SAME TARGET MULTIPLE TIMES. IF YOU CANNOT FIND THE NUMBER OF COPY TARGETS REQUESTED RETURN AS MANY AS YOU CAN.
              5. Invert the list so the most promising candidate is the last you return.
              6. Return 20 possible copy targets.

          Screen Content:

  "

  if [ -z "$SCREEN_CONTENT" ]; then
    echo "Error: No screen content received from stdin." >&2
    exit 1
  fi

  PROMPT="''${PROMPT_PREFIX}''${SCREEN_CONTENT}"
  JSON_PAYLOAD=""
  CURL_COMMAND_ARGS=()

  if [[ "$API_PROVIDER" == "google" ]]; then
    JSON_PAYLOAD="
      {
        \"contents\": [
          {
            \"parts\": [
              {
                \"text\": ''$(jq -sRc '.' <<< "''$PROMPT")
              }
            ]
          }
        ],
        \"generationConfig\": {
          \"maxOutputTokens\": 1500
        }
      }
    "
    CURL_COMMAND_ARGS=(
      -s -X POST
      -H 'Content-Type: application/json'
      --data "$JSON_PAYLOAD"
      "$CURRENT_API_ENDPOINT"
    )
  elif [[ "$API_PROVIDER" == "groq" ]]; then
    JSON_PAYLOAD="
      {
        \"model\": \"''${CURRENT_MODEL}\",
        \"messages\": [{
          \"role\": \"user\",
          \"content\": ''$(jq -sRc '.' <<< "''$PROMPT")
        }],
        \"max_tokens\": 1500
      }
    "
    CURL_COMMAND_ARGS=(
      -s -X POST
      -H "Authorization: Bearer ''${CURRENT_API_KEY}"
      -H 'Content-Type: application/json'
      --data "$JSON_PAYLOAD"
      "$CURRENT_API_ENDPOINT"
    )
  fi

  LLM_RESPONSE=$(curl "''${CURL_COMMAND_ARGS[@]}")

  if [ -z "$LLM_RESPONSE" ]; then
    echo "Error: Empty response from $CURRENT_API_PROVIDER_NAME API." >&2
    exit 1
  fi

  COPY_TARGETS=""
  if [[ "$API_PROVIDER" == "google" ]]; then
    if echo "$LLM_RESPONSE" | jq -e '.error' > /dev/null; then
      ERROR_MESSAGE=$(echo "$LLM_RESPONSE" | jq -r '.error.message')
      echo "Error from Google API: $ERROR_MESSAGE" >&2
      echo "Full Google API response: $LLM_RESPONSE" >&2
      exit 1
    fi
    if ! echo "$LLM_RESPONSE" | jq -e '.candidates[0].content.parts[0].text' > /dev/null 2>&1; then
      echo "Error: Unexpected response structure from Google API or no content." >&2
      echo "Google API Response: $LLM_RESPONSE" >&2
      exit 1
    fi
    COPY_TARGETS=$(echo "$LLM_RESPONSE" | jq -r '.candidates[0].content.parts[0].text')
  elif [[ "$API_PROVIDER" == "groq" ]]; then
    if echo "$LLM_RESPONSE" | jq -e '.error' > /dev/null; then
      ERROR_MESSAGE=$(echo "$LLM_RESPONSE" | jq -r '.error.message')
      echo "Error from Groq API: $ERROR_MESSAGE" >&2
      echo "Full Groq API response: $LLM_RESPONSE" >&2
      exit 1
    fi
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

  SELECTED_TARGET=$(echo -e "$COPY_TARGETS" | fzf --no-sort --reverse)

  if [ -z "$SELECTED_TARGET" ]; then
    echo "No item selected in fzf. Aborting." >&2
    exit 0
  fi

  if command -v wl-copy >/dev/null 2>&1; then
    echo -n "$SELECTED_TARGET" | wl-copy
    echo "Copied to Wayland clipboard." >&2
  elif command -v xclip >/dev/null 2>&1; then
    echo -n "$SELECTED_TARGET" | xclip -i -selection clipboard
    echo "Copied to X11 clipboard." >&2
  elif command -v clip.exe >/dev/null 2>&1; then
    echo -n "$SELECTED_TARGET" | clip.exe
    echo "Copied to Windows clipboard via clip.exe." >&2
  else
    echo "Warning: No clipboard tool (wl-copy, xclip, clip.exe) found. Printing to stdout:" >&2
    echo "$SELECTED_TARGET"
    exit 0
  fi

  exit 0
''
