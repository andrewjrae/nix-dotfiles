#!/usr/bin/env sh

p=5
monitor=$(hyprctl monitors -j | jaq -r '.[] | select(.focused == true) | .name')
if [ "$monitor" == "eDP-1" ]; then
    brightnessctl s $1 -d intel_backlight
else
    brightnessctl s $1
fi
