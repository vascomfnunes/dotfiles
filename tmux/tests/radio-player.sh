#!/bin/sh
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
cat > "$tmp/fzf" <<'MOCK'
#!/bin/sh
case " $* " in
  *' --height=100% '*) ;;
  *) echo 'Radio selector does not fill its pane' >&2; exit 1 ;;
esac
case " $* " in
  *'--header=↑/↓ Ctrl-N/P: move  Enter: play
Ctrl-S: stop  Ctrl-X: quit'*) ;;
  *) echo 'Missing compact radio help' >&2; exit 1 ;;
esac
case " $* " in
  *' --bind=esc:ignore,ctrl-x:abort,ctrl-n:down,ctrl-p:up '*) ;;
  *) echo 'Missing radio key bindings' >&2; exit 1 ;;
esac
for direction in 'h -L' 'j -D' 'k -U' 'l -R'; do
  key=${direction% *}
  pane_direction=${direction#* }
  case " $* " in
    *" --bind=ctrl-$key:execute-silent(tmux select-pane -t \"\$TMUX_PANE\" $pane_direction) "*) ;;
    *) echo "Missing pane navigation binding for Ctrl-$key" >&2; exit 1 ;;
  esac
done
count=0
[ ! -f "$RADIO_TEST_DIR/count" ] || count=$(cat "$RADIO_TEST_DIR/count")
count=$((count + 1))
printf '%s\n' "$count" > "$RADIO_TEST_DIR/count"
case $count in
  1) printf '\nStation\thttps://example.test/stream\n' ;;
  2) printf 'ctrl-s\nStation\thttps://example.test/stream\n' ;;
  *) exit 130 ;;
esac
MOCK
cat > "$tmp/mpv" <<'MOCK'
#!/bin/sh
printf '%s\n' "$@" > "$RADIO_TEST_DIR/args"
exec sleep 30
MOCK
chmod +x "$tmp/fzf" "$tmp/mpv"
PATH="$tmp:$PATH"
RADIO_TEST_DIR="$tmp"
RADIO_STATE_DIR="$tmp/state"
RADIO_STATIONS="$tmp/stations"
export PATH RADIO_TEST_DIR RADIO_STATE_DIR RADIO_STATIONS
printf 'Station\thttps://example.test/stream\n' > "$RADIO_STATIONS"
sh "$root/tmux/scripts/radio-player.sh"
[ "$(cat "$tmp/count")" = 3 ]
[ ! -e "$RADIO_STATE_DIR" ]
