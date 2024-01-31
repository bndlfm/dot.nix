#!/usr/bin/env sh
# Check if swayidle is running
if pgrep swayidle >/dev/null; then
	# If swayidle is running, kill it and swaylock
	killall swayidle >/dev/null 2>&1
	killall swaylock >/dev/null 2>&1
	notify-send "Disabled idle/lock."
else
	# If swayidle is not running, start two daemonized copies of swayidle
	swayidle -w timeout 600 "if pgrep -x swaylock; then hyprctl dispatch dpms off; fi" resume "hyprctl dispatch dpms on" &
	swayidle -w timeout 900 'swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2' timeout 930 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' &
	notify-send "Enabled idle/lock."
fi
