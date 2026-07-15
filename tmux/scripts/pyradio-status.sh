#!/bin/sh
# Prints pyradio's current song title for the tmux status bar.
# Reads it from pyradio's remote-control server (localhost:9998).
# Prints nothing when pyradio isn't running or the player is stopped.

# PyRadio exposes the title as a server-sent-events payload; strip the field
# prefix and any HTML tags before handing the text to tmux.
title=$(curl -sf --max-time 1 http://localhost:9998/title 2>/dev/null \
  | sed -n 's/^data: *//p' \
  | sed 's/<[^>]*>//g')

case $title in
  '' | *'Player is stopped'* | *'Playback stopped'*) exit 0 ;;
esac

printf '♪ %.60s  ' "$title"
