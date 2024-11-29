#!/bin/bash

# Get the current system appearance
APPEARANCE=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

# Set the tmux configuration file based on the system appearance
if [ "$APPEARANCE" == "Dark" ]; then
    tmux source-file ~/.tmux/themes/gruvbox_dark.conf
else
    tmux source-file ~/.tmux/themes/gruvbox_light.conf
fi
