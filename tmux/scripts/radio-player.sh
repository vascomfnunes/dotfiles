#!/bin/sh
# Select stations while mpv plays in the background. Closing fzf stops playback.
set -eu

stations="${RADIO_STATIONS:-$HOME/.config/radio/stations.tsv}"
# macOS TMPDIR paths can exceed the Unix socket path length limit.
state_dir="${RADIO_STATE_DIR:-/tmp/tmux-radio-$(id -u)}"
mpv_pid=''

if ! mkdir -m 700 "$state_dir" 2>/dev/null; then
  echo "Radio state directory already exists: $state_dir" >&2
  echo 'Stop the other radio player, or remove the stale directory.' >&2
  exit 1
fi

stop_player() {
  if [ -n "$mpv_pid" ]; then
    kill "$mpv_pid" 2>/dev/null || true
    wait "$mpv_pid" 2>/dev/null || true
    mpv_pid=''
  fi
  rm -f "$state_dir/mpv.sock" "$state_dir/station"
}
cleanup() {
  stop_player
  rmdir "$state_dir" 2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 0' HUP INT TERM

if [ ! -r "$stations" ]; then
  echo "Station list not found: $stations" >&2
  exit 1
fi

while :; do
  # The fzf action shell expands TMUX_PANE when a navigation key is pressed.
  # shellcheck disable=SC2016
  choice=$(fzf --height=100% --delimiter="$(printf '\t')" --with-nth=1 \
    --prompt='Radio > ' --header='↑/↓ Ctrl-N/P: move  Enter: play
Ctrl-S: stop  Ctrl-X: quit' \
    --bind='esc:ignore,ctrl-x:abort,ctrl-n:down,ctrl-p:up' \
    --bind='ctrl-h:execute-silent(tmux select-pane -t "$TMUX_PANE" -L)' \
    --bind='ctrl-j:execute-silent(tmux select-pane -t "$TMUX_PANE" -D)' \
    --bind='ctrl-k:execute-silent(tmux select-pane -t "$TMUX_PANE" -U)' \
    --bind='ctrl-l:execute-silent(tmux select-pane -t "$TMUX_PANE" -R)' \
    --expect=ctrl-s < "$stations") || break
  key=$(printf '%s\n' "$choice" | sed -n '1p')
  if [ "$key" = ctrl-s ]; then
    stop_player
    continue
  fi
  entry=$(printf '%s\n' "$choice" | sed -n '2p')
  tab=$(printf '\t')
  case $entry in *"$tab"*) ;; *) continue ;; esac
  name=${entry%%"$tab"*}
  url=${entry#*"$tab"}
  [ -n "$name" ] && [ -n "$url" ] || continue
  stop_player
  printf '%s\n' "$name" > "$state_dir/station"
  mpv --no-config --no-video --no-terminal --input-terminal=no \
    --input-ipc-server="$state_dir/mpv.sock" -- "$url" >/dev/null 2>&1 &
  mpv_pid=$!
done
