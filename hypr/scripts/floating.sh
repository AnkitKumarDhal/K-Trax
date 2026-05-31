#!/bin/bash

# Check if the currently focused window is floating
is_floating=$(hyprctl activewindow -j | jq -r '.floating')

if [ "$is_floating" = "true" ]; then
    # If floating, switch focus to tiled window
    hyprctl dispatch focuswindow tiled
else
    # If tiled or anything else, switch focus to floating window
    hyprctl dispatch focuswindow floating
fi
