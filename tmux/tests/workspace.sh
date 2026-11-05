#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
cat > "$tmp/tmux" <<'MOCK'
#!/bin/sh
printf '%s\n' "$*" >> "$WORKSPACE_TEST_LOG"
case $1 in
  has-session) exit 1 ;;
  new-session) printf '%s\n' '$1 @1 %1' ;;
esac
MOCK
cat > "$tmp/nvim" <<'MOCK'
#!/bin/sh
exit "$WORKSPACE_TEST_SERVER_STATUS"
MOCK
chmod +x "$tmp/tmux" "$tmp/nvim"
PATH="$tmp:$PATH"
WORKSPACE_TEST_LOG="$tmp/log"
NVIM_SERVER="$tmp/server.sock"
export PATH WORKSPACE_TEST_LOG NVIM_SERVER
for WORKSPACE_TEST_SERVER_STATUS in 0 1; do
  export WORKSPACE_TEST_SERVER_STATUS
  : > "$WORKSPACE_TEST_LOG"
  TMUX='test' sh "$root/tmux/scripts/workspace.sh"
  grep -F "new-window -d -t \$1: -n nvim -c " "$WORKSPACE_TEST_LOG" >/dev/null
  grep -F "new-window -d -t \$1: -n opencode -c " "$WORKSPACE_TEST_LOG" >/dev/null
  grep -F "send-keys -t \$1:opencode -l opencode" "$WORKSPACE_TEST_LOG" >/dev/null
  if [ "$WORKSPACE_TEST_SERVER_STATUS" = 0 ]; then
    grep -Fx "send-keys -t \$1:nvim -l nvim" "$WORKSPACE_TEST_LOG" >/dev/null
  else
    grep -Fx "send-keys -t \$1:nvim -l nvim --listen '$NVIM_SERVER'" "$WORKSPACE_TEST_LOG" >/dev/null
  fi
done
