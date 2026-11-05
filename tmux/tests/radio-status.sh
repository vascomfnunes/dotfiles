#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
cat > "$tmp/nc" <<'MOCK'
#!/bin/sh
cat >/dev/null
printf '%s\n' "$RADIO_TEST_JSON"
MOCK
chmod +x "$tmp/nc"
PATH="$tmp:$PATH"
RADIO_STATE_DIR="$tmp/state"
export PATH RADIO_STATE_DIR RADIO_TEST_JSON
mkdir "$RADIO_STATE_DIR"
printf '%s\n' Station > "$RADIO_STATE_DIR/station"

RADIO_TEST_JSON='{"error":"success","data":{"icy-title":"Artist #1 - Song"}}'
[ "$(sh "$root/tmux/scripts/radio-status.sh" --title)" = 'Artist #1 - Song' ]
[ "$(sh "$root/tmux/scripts/radio-status.sh")" = '♪ Artist ##1 - Song  ' ]

RADIO_TEST_JSON='{"error":"success","data":{"artist":"Artist","title":"Song"}}'
[ "$(sh "$root/tmux/scripts/radio-status.sh" --title)" = 'Artist - Song' ]

RADIO_TEST_JSON='{"error":"success","data":{}}'
[ "$(sh "$root/tmux/scripts/radio-status.sh" --title)" = 'Playing: Station' ]

RADIO_TEST_JSON='{"error":"property unavailable"}'
[ "$(sh "$root/tmux/scripts/radio-status.sh" --title)" = 'Playing: Station' ]
RADIO_TEST_JSON='{"error":"unknown command"}'
[ -z "$(sh "$root/tmux/scripts/radio-status.sh" --title)" ]
rm "$RADIO_STATE_DIR/station"
[ -z "$(sh "$root/tmux/scripts/radio-status.sh" --title)" ]
