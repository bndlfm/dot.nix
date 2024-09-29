#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar.log &
MONITOR=DP-3 polybar left 2>&1 | tee -a /tmp/polybardp3.log &
MONITOR=DP-0 polybar center 2>&1 | tee -a /tmp/polybardp0.log &
MONITOR=HDMI-0 polybar right 2>&1 | tee -a /tmp/polybarhdmi0.log &

echo "Bars launched..."
