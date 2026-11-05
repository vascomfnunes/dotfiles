#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
cat > "$tmp/tmux" <<'MOCK'
#!/bin/sh
printf '%s\n' "$*" >> "$WORKSPACE_TEST_LOG"
case $1 in
  has-session) [ -f "$WORKSPACE_TEST_STARTED" ] ;;
  list-sessions) exit 1 ;;
  new-session) printf '%s\n' '$1 @1 %1' ;;
  display-message) printf '%s\n' '$1 @1 %1' ;;
esac
MOCK
cat > "$tmp/uname" <<'MOCK'
#!/bin/sh
echo Darwin
MOCK
cat > "$tmp/launchctl" <<'MOCK'
#!/bin/sh
printf 'launchctl %s\n' "$*" >> "$WORKSPACE_TEST_LOG"
if [ "$1" = submit ]; then
  touch "$WORKSPACE_TEST_STARTED"
fi
MOCK
cat > "$tmp/nvim" <<'MOCK'
#!/bin/sh
exit "$WORKSPACE_TEST_SERVER_STATUS"
MOCK
chmod +x "$tmp/tmux" "$tmp/nvim" "$tmp/uname" "$tmp/launchctl"
PATH="$tmp:$PATH"
WORKSPACE_TEST_LOG="$tmp/log"
NVIM_SERVER="$tmp/server.sock"
WORKSPACE_TEST_STARTED="$tmp/started"
export PATH WORKSPACE_TEST_LOG NVIM_SERVER WORKSPACE_TEST_STARTED
for WORKSPACE_TEST_SERVER_STATUS in 0 1; do
  export WORKSPACE_TEST_SERVER_STATUS
  : > "$WORKSPACE_TEST_LOG"
  TERM_PROGRAM='' TMUX='test' sh "$root/tmux/scripts/workspace.sh"
  grep -F "new-window -d -t \$1: -n nvim -c " "$WORKSPACE_TEST_LOG" >/dev/null
  grep -F "new-window -d -t \$1: -n opencode -c " "$WORKSPACE_TEST_LOG" >/dev/null
  grep -F "send-keys -t \$1:opencode -l opencode" "$WORKSPACE_TEST_LOG" >/dev/null
  if [ "$WORKSPACE_TEST_SERVER_STATUS" = 0 ]; then
    grep -Fx "send-keys -t \$1:nvim -l nvim" "$WORKSPACE_TEST_LOG" >/dev/null
  else
    grep -Fx "send-keys -t \$1:nvim -l nvim --listen '$NVIM_SERVER'" "$WORKSPACE_TEST_LOG" >/dev/null
  fi
done

: > "$WORKSPACE_TEST_LOG"
TERM_PROGRAM=ghostty sh "$root/tmux/scripts/workspace.sh"
grep -F 'launchctl submit -l dotfiles.tmux-workspace.' "$WORKSPACE_TEST_LOG" >/dev/null
grep -F 'display-message -p -t ' "$WORKSPACE_TEST_LOG" >/dev/null
grep -F 'launchctl remove dotfiles.tmux-workspace.' "$WORKSPACE_TEST_LOG" >/dev/null
grep -F "send-keys -t \$1:opencode -l opencode" "$WORKSPACE_TEST_LOG" >/dev/null
