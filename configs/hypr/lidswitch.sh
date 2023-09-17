#!/usr/bin/env sh

if hyprctl monitors | grep "Monitor" | grep -v "eDP-1"; then
    hyprctl keyword monitor "eDP-1, disable"
    eww open bar
else
    systemctl suspend
fi
