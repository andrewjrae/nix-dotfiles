#!/usr/bin/env sh

if hyprctl monitors | grep HDMI; then
    hyprctl keyword monitor "eDP-1, disable"
else
    systemctl suspend
fi
