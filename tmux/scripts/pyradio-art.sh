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
settle_interval="${PYRADIO_ART_SETTLE:-1}"
cache_dir="${TMPDIR:-/tmp}/tmux-pyradio-art"
fallback_art="${PYRADIO_ART_FALLBACK:-$HOME/.config/pyradio/assets/generic-cover.png}"
mkdir -p "$cache_dir"
render_output="$cache_dir/render.$$"
synchronized_output=0

end_synchronized_output() {
  [ "$synchronized_output" -eq 1 ] || return 0
  printf '\033[?2026l'
  synchronized_output=0
}

cleanup() {
  end_synchronized_output
  rm -f "$render_output"
}
trap cleanup EXIT

# Track changes continue while another tmux window is selected. Permit this
# pane's Kitty uploads to reach the attached client even when the pane is not
# visible; the default "on" setting only forwards passthrough from visible
# panes. Scope the less restrictive setting to this pane instead of globally.
if [ -n "${TMUX:-}" ] && [ -n "${TMUX_PANE:-}" ]; then
  tmux set-option -p -t "$TMUX_PANE" allow-passthrough all
fi

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

# The workspace is assembled before a client attaches, while tmux still uses
# its small fallback size. Do not paint at that temporary geometry: Kitty
# images are placed in terminal pixels and cannot be corrected by tmux when
# the pane subsequently grows. Wait for an attached client and a stable pane
# size before the first render. An attached client is not quite the same as a
# ready client: tmux can still be painting its initial screen after this
# returns. The main loop therefore schedules one extra paint shortly after the
# first artwork frame as well.
wait_for_stable_geometry() {
  [ -n "${TMUX:-}" ] && [ -n "${TMUX_PANE:-}" ] || return 0

  while [ "$(tmux display-message -p -t "$TMUX_PANE" \
    '#{session_attached}' 2>/dev/null || printf 1)" = 0 ]; do
    read -rsn1 -t 0.1 key || true
    case ${key:-} in q | $'\e') exit 0 ;; esac
  done

  previous_geometry=''
  stable_samples=0
  while [ "$stable_samples" -lt 2 ]; do
    geometry=$(tmux display-message -p -t "$TMUX_PANE" \
      '#{pane_width}x#{pane_height}' 2>/dev/null || true)
    [ -n "$geometry" ] || return 0
    if [ "$geometry" = "$previous_geometry" ]; then
      stable_samples=$((stable_samples + 1))
    else
      previous_geometry=$geometry
      stable_samples=0
    fi
    read -rsn1 -t 0.1 key || true
    case ${key:-} in q | $'\e') exit 0 ;; esac
  done
}

# Downloads cover art for the given "Artist - Title" string into the cache and
# prints the file path. Prints nothing when the lookup finds no match.
art_for() {
  title=$1

  # PyRadio uses "Playing: ..." for stream status rather than track metadata.
  # Do not search iTunes for it; returning no result selects the generic cover.
  case $title in
    Playing:*) return 0 ;;
  esac

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

# Delete only the image created by this process. Kitty's capital-I deletion
# also releases its stored image data; the tmux form doubles the inner escapes
# so allow-passthrough can forward the command to the outer terminal.
kitty_image_id=''
clear_kitty_art() {
  [ -n "$kitty_image_id" ] || return 0

  if [ -n "${TMUX:-}" ]; then
    printf '\033Ptmux;\033\033_Ga=d,d=I,i=%s,q=2\033\033\x5c\033\x5c' \
      "$kitty_image_id"
  else
    printf '\033_Ga=d,d=I,i=%s,q=2\033\x5c' "$kitty_image_id"
  fi
  kitty_image_id=''
}

render() {
  title=$1
  cols=$(tput cols)
  rows=$(tput lines)
  # Leave a blank line between the art and the title row.
  art_rows=$((rows - 4))
  art_cols=$cols
  [ "$art_cols" -gt 40 ] && art_cols=40
  [ "$art_rows" -gt 19 ] && art_rows=19
  [ "$art_cols" -lt 1 ] && art_cols=1
  [ "$art_rows" -lt 1 ] && art_rows=1

  art=$(art_for "$title" || true)
  if [ -z "$art" ] && [ -s "$fallback_art" ]; then
    art=$fallback_art
  fi

  next_kitty_image_id=''
  if [ -n "$art" ]; then
    chafa --format kitty --passthrough tmux --align mid,mid \
      --size "${art_cols}x${art_rows}" "$art" >"$render_output"
    next_kitty_image_id=$(head -c 256 "$render_output" | tr ',' '\n' \
      | sed -n 's/^i=\([0-9][0-9]*\).*/\1/p' | head -n 1)
  fi

  # Chafa's Kitty placeholders are multi-codepoint grapheme clusters. If tmux
  # flushes them piecemeal, Ghostty can temporarily associate cells with the
  # wrong image rows or columns even though tmux's final pane grid is correct.
  # Synchronized output makes tmux publish the clear, image placement and
  # title as one completed screen update.
  if [ -n "${TMUX:-}" ]; then
    printf '\033[?2026h'
    synchronized_output=1
  fi

  clear_kitty_art
  clear
  if [ -n "$art" ]; then
    kitty_image_id=$next_kitty_image_id
    cat "$render_output"
  else
    text='(no artwork)'
    tput cup $((rows / 2)) $(((cols - ${#text}) / 2))
    printf '%s' "$text"
  fi

  # Track text centered on the bottom row, truncated to the pane width and
  # tinted like the status bar's "now playing" segment (theme's @radio_fg).
  text="♪ $title"
  [ ${#text} -gt "$cols" ] && text="${text:0:cols}"
  tput cup $((rows - 2)) $(((cols - ${#text}) / 2))
  color=$(tmux show -gqv @radio_fg 2>/dev/null || true)
  case $color in
    '#'??????)
      printf '\033[38;2;%d;%d;%dm%s\033[0m' \
        $((16#${color:1:2})) $((16#${color:3:2})) $((16#${color:5:2})) "$text"
      ;;
    *) printf '%s' "$text" ;;
  esac

  end_synchronized_output
}

# Redraw on resize (also fires on client reattach, which wipes the image).
trap 'shown=""' WINCH

wait_for_stable_geometry

shown=''
shown_geometry=''
first_art_painted=0
while :; do
  next_poll_interval=$poll_interval
  title=$(current_title || true)
  geometry="$(tput cols)x$(tput lines)"
  case $title in
    '' | *'Player is stopped'* | *'Playback stopped'*)
      if [ "$shown" != stopped ] || [ "$geometry" != "$shown_geometry" ]; then
        clear_kitty_art
        clear
        text='pyradio is not playing'
        tput cup $(($(tput lines) / 2)) $((($(tput cols) - ${#text}) / 2))
        printf '%s' "$text"
        shown=stopped
        shown_geometry=$geometry
      fi
      ;;
    *)
      if [ "$title" != "$shown" ] || [ "$geometry" != "$shown_geometry" ]; then
        render "$title"
        shown=$title
        shown_geometry=$geometry
        if [ "$first_art_painted" -eq 0 ]; then
          # During client attachment tmux may accept passthrough output before
          # the outer terminal is ready, then overwrite that image with its
          # initial screen repaint. Retry once after the attach has settled;
          # this is the same repaint that changing panes or resizing triggers.
          first_art_painted=1
          shown=''
          next_poll_interval=$settle_interval
        fi
      fi
      ;;
  esac

  # Poll for the next song, letting a keypress interrupt early.
  key=''
  read -rsn1 -t "$next_poll_interval" key || true
  case $key in q | $'\e') exit 0 ;; esac
done
