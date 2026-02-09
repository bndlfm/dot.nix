{ pkgs }:
pkgs.writeShellScript "attachWindowToCurrentTab.sh" ''
  #!/usr/bin/env bash
  set -euo pipefail

  # Ask kitty to pick a source window, then move it into the current tab.
  selected_window="$(kitten @ select-window --title "Attach which window?" --exclude-active || true)"
  if [ -z "''${selected_window:-}" ]; then
    exit 0
  fi

  kitten @ detach-window --match "id:''${selected_window}" --target-tab recent:0 --stay-in-tab
''
