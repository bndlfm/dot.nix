#!/usr/bin/env sh
######################################
#           Author: bndlfm           #
# Move Hyprland windows with hyprctl #
#   different if floating or tiled   #
######################################

floating_value=$(hyprctl activewindow | grep -e "floating:" | awk '{print $2}')

if [ "$floating_value" = "0" ] && [ "$1" ]; then
    if [ "$1" = "L" ] || [ "$1" = "l" ]; then
        hyprctl dispatch movewindow l
    elif [ "$1" = "R" ] || [ "$1" = "r" ]; then
        hyprctl dispatch movewindow r
    elif [ "$1" = "U" ] || [ "$1" = "u" ]; then
        hyprctl dispatch movewindow u
    elif [ "$1" = "D" ] || [ "$1" = "d" ]; then
        hyprctl dispatch movewindow d
    fi

elif [ "$floating_value" = "1" ] && [ "$1" ]; then
    if [ "$1" = "L" ] || [ "$1" = "l" ]; then
        hyprctl dispatch moveactive -100 0
    elif [ "$1" = "R" ] || [ "$1" = "r" ]; then
        hyprctl dispatch moveactive 100 0
    elif [ "$1" = "U" ] || [ "$1" = "u" ]; then
        hyprctl dispatch moveactive 0 -100
    elif [ "$1" = "D" ] || [ "$1" = "d" ]; then
        hyprctl dispatch moveactive 0 100 
    fi
fi
