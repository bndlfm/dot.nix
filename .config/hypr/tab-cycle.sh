#!/usr/bin/env sh
######################################
#           Author: bndlfm           #
# Move Hyprland windows with hyprctl #
#   different if floating or tiled   #
######################################

grouped_value=$(hyprctl activewindow | grep -e "grouped:" | awk '{print $2}')

if [ "$grouped_value" = "0" ]; then
        hyprctl dispatch cyclenext
        hyprctl dispatch bringactivetotop
elif [ "$grouped_value" != "0" ]; then
        hyprctl dispatch changegroupactive
fi
