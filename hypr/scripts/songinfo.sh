#!/usr/bin/env bash

# Check if a player is running, then output the formatted string
if playerctl status &>/dev/null; then
    playerctl metadata --format '󰎆  {{ title }} - {{ artist }}'
else
    echo ""
fi
