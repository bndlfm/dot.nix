{ pkgs }: {
  home.packages = [
    (pkgs.writeShellScriptBin "hkill" /* sh */ ''
      #!${pkgs.bash}/bin/bash

      # Function to get the PID of the active window
      get_pid() {
        window_info=$(${pkgs.hyprland}/bin/hyprctl activewindow -j)
        pid=$(echo "$window_info" | ${pkgs.jq}/bin/jq '.pid')
        echo "$pid"
      }

      pid=$(get_pid) # Get the PID of the active window

      if [ -n "$pid" ] && [ "$pid" != "null" ]; then
          ${pkgs.coreutils}/bin/kill -9 "$pid" # Kill the process
          ${pkgs.libnotify}/bin/notify-send "Window Killer" "Process $pid terminated." # Notify the user
      else
        ${pkgs.libnotify}/bin/notify-send "Window Killer" "Failed to get window information."
      fi
    '')
  ];
}
