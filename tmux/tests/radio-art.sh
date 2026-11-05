#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp/bin" "$tmp/home/.local/bin" "$tmp/cache"
cat > "$tmp/home/.local/bin/tmux-radio-status" <<'MOCK'
#!/bin/sh
count=0
[ ! -f "$ART_TEST_DIR/count" ] || count=$(cat "$ART_TEST_DIR/count")
count=$((count + 1))
printf '%s\n' "$count" > "$ART_TEST_DIR/count"
case $count in
  1|2) printf '%s\n' 'Playing: First' ;;
  3|4) printf '%s\n' 'Playing: Second' ;;
  *) kill -TERM "$PPID" ;;
esac
MOCK
cat > "$tmp/bin/tmux" <<'MOCK'
#!/bin/sh
case "$*" in
  *'#{session_name}'*) printf '%s\n' dotfiles-radio-test ;;
  *'#{session_attached}'*) printf '%s\n' 1 ;;
  *'#{pane_width}x#{pane_height}'*) printf '%s\n' 40x20 ;;
esac
MOCK
cat > "$tmp/bin/tput" <<'MOCK'
#!/bin/sh
case $1 in cols) echo 40 ;; lines) echo 20 ;; esac
MOCK
cat > "$tmp/bin/chafa" <<'MOCK'
#!/bin/sh
printf 'render\n' >> "$ART_TEST_DIR/renders"
printf '\033Ptmux;\033\033_Ga=T,i=123,m=0;test\033\033\\\033\\'
MOCK
cat > "$tmp/bin/clear" <<'MOCK'
#!/bin/sh
exit 0
MOCK
chmod +x "$tmp/bin/"* "$tmp/home/.local/bin/tmux-radio-status"
printf 'art' > "$tmp/fallback"
ART_TEST_DIR="$tmp" HOME="$tmp/home" PATH="$tmp/bin:$PATH" \
  TMPDIR="$tmp/cache" RADIO_ART_FALLBACK="$tmp/fallback" TMUX=test TMUX_PANE=%1 \
  bash "$root/tmux/scripts/radio-art.sh" </dev/null > "$tmp/output" 2>/dev/null || :
[ "$(wc -l < "$tmp/renders" | tr -d ' ')" = 4 ]
grep -F 'Playing: First' "$tmp/output" >/dev/null
grep -F 'Playing: Second' "$tmp/output" >/dev/null

# A transient search failure must not leave one track without art indefinitely.
cat > "$tmp/home/.local/bin/tmux-radio-status" <<'MOCK'
#!/bin/sh
count=0
[ ! -f "$ART_TEST_DIR/polls" ] || count=$(cat "$ART_TEST_DIR/polls")
count=$((count + 1))
printf '%s\n' "$count" > "$ART_TEST_DIR/polls"
[ "$count" -le 4 ] || kill -TERM "$PPID"
printf '%s\n' 'Artist - Song'
MOCK
cat > "$tmp/bin/curl" <<'MOCK'
#!/bin/sh
case "$*" in
  *itunes.apple.com*)
    count=0
    [ ! -f "$ART_TEST_DIR/searches" ] || count=$(cat "$ART_TEST_DIR/searches")
    count=$((count + 1))
    printf '%s\n' "$count" > "$ART_TEST_DIR/searches"
    [ "$count" -gt 2 ] || exit 1
    printf '%s\n' '{"results":[{"artworkUrl100":"https://example.test/100x100.jpg"}]}'
    ;;
  *)
    while [ "$#" -gt 0 ]; do
      if [ "$1" = -o ]; then printf 'art' > "$2"; exit 0; fi
      shift
    done
    exit 1
    ;;
esac
MOCK
chmod +x "$tmp/bin/curl" "$tmp/home/.local/bin/tmux-radio-status"
rm -f "$tmp/renders"
ART_TEST_DIR="$tmp" HOME="$tmp/home" PATH="$tmp/bin:$PATH" \
  TMPDIR="$tmp/cache" RADIO_ART_RETRY=0 TMUX=test TMUX_PANE=%1 \
  bash "$root/tmux/scripts/radio-art.sh" </dev/null > "$tmp/retry-output" 2>/dev/null || :
[ "$(cat "$tmp/searches")" -ge 3 ]
[ -s "$tmp/renders" ]

# A popup can detach and reattach between polls while the title stays the same.
# An attachment notification must trigger one repaint after settling.
cat > "$tmp/home/.local/bin/tmux-radio-status" <<'MOCK'
#!/bin/sh
count=0
[ ! -f "$ART_TEST_DIR/reattach-polls" ] || count=$(cat "$ART_TEST_DIR/reattach-polls")
count=$((count + 1))
printf '%s\n' "$count" > "$ART_TEST_DIR/reattach-polls"
[ "$count" -le 5 ] || kill -TERM "$PPID"
printf '%s\n' 'Playing: Same track'
MOCK
chmod +x "$tmp/home/.local/bin/tmux-radio-status"
rm -f "$tmp/renders"
# Three geometry samples, two initial polls, then repeated attachment events.
printf 'xxxxx\022\022\022' > "$tmp/keys"
ART_TEST_DIR="$tmp" HOME="$tmp/home" PATH="$tmp/bin:$PATH" \
  TMPDIR="$tmp/cache" RADIO_ART_FALLBACK="$tmp/fallback" TMUX=test TMUX_PANE=%1 \
  bash "$root/tmux/scripts/radio-art.sh" < "$tmp/keys" > "$tmp/reattach-output" 2>/dev/null || :
[ "$(wc -l < "$tmp/renders" | tr -d ' ')" = 3 ]
