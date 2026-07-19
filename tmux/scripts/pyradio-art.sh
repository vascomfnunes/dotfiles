#!/usr/bin/env bash
# Shows cover art for the song currently playing in pyradio.
# Runs inside a tmux popup or a regular pane (see the bindings in tmux.conf).
#
# Radio streams only carry an "Artist - Title" text tag, never images, so the
# art comes from the iTunes Search API keyed on that tag. Results are cached
# per song. Rendered with chafa (kitty graphics protocol through tmux).
# Press q (or Esc) to close; the popup refreshes when the song changes.

set -eu

poll_interval="${PYRADIO_ART_POLL:-5}"
cache_dir="${TMPDIR:-/tmp}/tmux-pyradio-art"
mkdir -p "$cache_dir"

# The OS already purges stale temp files, but trim anything older than a week
# ourselves so the cache stays small even on long-uptime machines.
find "$cache_dir" -type f -mtime +7 -delete 2>/dev/null || true

current_title() {
  # PyRadio exposes the title as a server-sent-events payload; strip the field
  # prefix and any HTML tags.
  curl -sf --max-time 1 http://localhost:9998/title 2>/dev/null \
    | sed -n 's/^data: *//p' \
    | sed 's/<[^>]*>//g'
}

# Downloads cover art for the given "Artist - Title" string into the cache and
# prints the file path. Prints nothing when the lookup finds no match.
art_for() {
  title=$1
  cache_file="$cache_dir/$(printf '%s' "$title" | md5 -q).jpg"

  if [ ! -s "$cache_file" ]; then
    term=$(jq -rn --arg q "$title" '$q|@uri')
    # artworkUrl100 is a 100x100 thumbnail; the CDN serves any size you ask
    # for by rewriting that path segment.
    url=$(curl -sf --max-time 5 \
      "https://itunes.apple.com/search?term=${term}&media=music&limit=1" \
      | jq -r '.results[0].artworkUrl100 // empty' \
      | sed 's/100x100/600x600/')
    [ -n "$url" ] && curl -sf --max-time 5 -o "$cache_file" "$url"
  fi

  [ -s "$cache_file" ] && printf '%s' "$cache_file"
}

render() {
  title=$1
  cols=$(tput cols)
  rows=$(tput lines)
  art_rows=$((rows - 3))

  clear
  art=$(art_for "$title" || true)
  if [ -n "$art" ]; then
    chafa --format kitty --passthrough tmux --align mid,mid \
      --size "${cols}x${art_rows}" "$art"
  else
    text='(no artwork)'
    tput cup $((rows / 2)) $(((cols - ${#text}) / 2))
    printf '%s' "$text"
  fi

  # Track text centered on the bottom row, truncated to the pane width.
  text="♪ $title"
  [ ${#text} -gt "$cols" ] && text="${text:0:cols}"
  tput cup $((rows - 2)) $(((cols - ${#text}) / 2))
  printf '%s' "$text"
}

# Redraw on resize (also fires on client reattach, which wipes the image).
trap 'shown=""' WINCH

shown=''
while :; do
  title=$(current_title || true)
  case $title in
    '' | *'Player is stopped'* | *'Playback stopped'*)
      if [ "$shown" != stopped ]; then
        clear
        text='pyradio is not playing'
        tput cup $(($(tput lines) / 2)) $((($(tput cols) - ${#text}) / 2))
        printf '%s' "$text"
        shown=stopped
      fi
      ;;
    *)
      if [ "$title" != "$shown" ]; then
        render "$title"
        shown=$title
      fi
      ;;
  esac

  # Poll for the next song, letting a keypress interrupt early.
  key=''
  read -rsn1 -t "$poll_interval" key || true
  case $key in q | $'\e') exit 0 ;; esac
done
