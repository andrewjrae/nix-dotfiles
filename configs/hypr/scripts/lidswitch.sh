#!/usr/bin/env sh

sleep 0.5
if hyprctl monitors | grep "Monitor" | grep -v "eDP-1"; then
    hyprctl keyword monitor "eDP-1, disable"
    sleep 0.1
    eww open bar
else
    systemctl suspend
fi
