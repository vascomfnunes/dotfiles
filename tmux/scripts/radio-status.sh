#!/bin/sh
# The same unformatted track text feeds the cover-art pane and status bar.
state_dir="${RADIO_STATE_DIR:-/tmp/tmux-radio-$(id -u)}"
[ -r "$state_dir/station" ] || exit 0
station=$(cat "$state_dir/station")
response=$(printf '%s\n' '{"command":["get_property","metadata"]}' | \
  nc -U -w 1 "$state_dir/mpv.sock" 2>/dev/null) || exit 0

title=$(printf '%s\n' "$response" | jq -r --arg station "$station" '
  select(.error == "success" or .error == "property unavailable") | .data // {} |
  (.["icy-title"] // .["ICY-TITLE"] // .StreamTitle // .streamtitle //
    (if (.artist // "") != "" and (.title // "") != "" then
      .artist + " - " + .title
    else .title // "" end)) as $track |
  if $track == "" or $track == $station then "Playing: " + $station
  else $track end
' 2>/dev/null) || exit 0

[ -n "$title" ] || exit 0
if [ "${1:-}" = --title ]; then
  printf '%s\n' "$title"
else
  printf '♪ %.60s  ' "$title" | sed 's/#/##/g'
fi
