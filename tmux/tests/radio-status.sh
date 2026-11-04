#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
cat > "$tmp/halpradio" <<'EOF'
#!/bin/sh
printf '%s\n' "$RADIO_TEST_JSON"
EOF
chmod +x "$tmp/halpradio"
PATH="$tmp:$PATH"
export PATH

export RADIO_TEST_JSON
RADIO_TEST_JSON='{"status":"playing","track":"Artist #1 - Song"}'
[ "$(sh "$root/tmux/scripts/radio-status.sh" --title)" = 'Artist #1 - Song' ]
[ "$(sh "$root/tmux/scripts/radio-status.sh")" = '♪ Artist ##1 - Song  ' ]

RADIO_TEST_JSON='{"status":"playing","station_name":"Station","title":"Station"}'
[ "$(sh "$root/tmux/scripts/radio-status.sh" --title)" = 'Playing: Station' ]

RADIO_TEST_JSON='{"status":"stopped","track":"Old song"}'
[ -z "$(sh "$root/tmux/scripts/radio-status.sh" --title)" ]
