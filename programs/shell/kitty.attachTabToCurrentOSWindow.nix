{ pkgs }:
pkgs.writeShellScript "attachTabToCurrentOSWindow.sh" ''
  #!/usr/bin/env bash
  set -euo pipefail

  # Select any window in the tab you want to attach, then move that tab to this OS window.
  selected_window="$(kitten @ select-window --title "Attach which tab? (pick any window in that tab)" || true)"
  if [ -z "''${selected_window:-}" ]; then
    exit 0
  fi

  kitten @ detach-tab --match "window_id:''${selected_window}" --target-tab recent:0
''
