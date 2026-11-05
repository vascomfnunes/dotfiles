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
