#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
cat > "$tmp/tmux" <<'MOCK'
#!/bin/sh
case $1 in
  has-session) [ "$2" = -t ] && [ "$3" = "=dotfiles-radio-$USER" ] ;;
  set-option) [ "$2" = -t ] && [ "$3" = "dotfiles-radio-$USER" ] && [ "$4" = status ] && [ "$5" = off ] ;;
  set-hook) [ "$2" = -t ] && [ "$3" = "dotfiles-radio-$USER" ] && [ "$4" = client-attached ] && [ "$5" = "run-shell 'test -z \"#{@radio_art_pane}\" || tmux -S #{q:socket_path} send-keys -t #{q:@radio_art_pane} C-r'" ] ;;
  attach-session) [ "$2" = -t ] && [ "$3" = "=dotfiles-radio-$USER" ] && [ -z "${TMUX:-}" ] ;;
  *) exit 1 ;;
esac
MOCK
chmod +x "$tmp/tmux"
PATH="$tmp:$PATH" TMUX=test sh "$root/tmux/scripts/workspace.sh" --radio
