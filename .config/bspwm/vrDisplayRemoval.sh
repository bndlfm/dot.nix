#!/bin/bash

# Adds 'Desktop' to DP-0
bspc monitor DP-0 -a Desktop >/dev/null

# Move desktops from EXT to Laptop
for desktop in $(bspc query -D -m "${EXTERNAL}"); do
	bspc desktop $desktop --to-monitor "${LAPTOP}"
done

bspc monitor DP-0 --remove >/dev/null

bspc desktop Desktop -r
