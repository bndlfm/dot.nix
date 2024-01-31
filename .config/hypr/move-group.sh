#!/usr/bin/env sh
######################################
#           Author: bndlfm           #
# Move Hyprland windows with hyprctl #
#   different if floating or tiled   #
######################################

grouped_value=$(hyprctl activewindow | grep -e "grouped:" | awk '{print $2}')

if [ "$grouped_value" = "0" ] && [ "$1" ]; then
	if [ "$1" = "L" ] || [ "$1" = "l" ]; then
		hyprctl dispatch moveintogroup l
	elif [ "$1" = "R" ] || [ "$1" = "r" ]; then
		hyprctl dispatch moveintogroup r
	elif [ "$1" = "U" ] || [ "$1" = "u" ]; then
		hyprctl dispatch moveintogroup u
	elif [ "$1" = "D" ] || [ "$1" = "d" ]; then
		hyprctl dispatch moveintogroup d
	fi
elif [ "$grouped_value" != "0" ] && [ "$1" ]; then
	if [ "$1" = "L" ] || [ "$1" = "l" ]; then
		hyprctl dispatch moveoutofgroup l
	elif [ "$1" = "R" ] || [ "$1" = "r" ]; then
		hyprctl dispatch moveoutofgroup r
	elif [ "$1" = "U" ] || [ "$1" = "u" ]; then
		hyprctl dispatch moveoutofgroup u
	elif [ "$1" = "D" ] || [ "$1" = "d" ]; then
		hyprctl dispatch moveoutofgroup d
	fi
fi
