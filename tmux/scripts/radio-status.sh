#!/bin/sh
# The same unformatted track text feeds the cover-art pane and status bar.
# halpradio returns a stopped snapshot when no player is running.
title=$(halpradio current --json 2>/dev/null | jq -r '
  if .status == "playing" or .status == "buffering" then
    if (.track // "") != "" then .track
    elif (.artist // "") != "" and (.title // "") != "" then .artist + " - " + .title
    elif (.title // "") != "" and .title != .station_name then .title
    elif (.station_name // "") != "" then "Playing: " + .station_name
    else empty end
  else empty end
' 2>/dev/null) || exit 0

[ -n "$title" ] || exit 0
if [ "${1:-}" = --title ]; then
  printf '%s\n' "$title"
else
  # A hash in stream metadata must not be interpreted as a tmux format.
  printf '♪ %.60s  ' "$title" | sed 's/#/##/g'
fi
