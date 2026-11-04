#!/bin/sh

# Browse tmux panes running an AI agent, with a live capture of the selected
# pane. Bound to prefix + A, but it also works from a shell inside tmux.

set -eu

for dependency in tmux fzf; do
  if ! command -v "$dependency" >/dev/null 2>&1; then
    printf '%s is not installed\n' "$dependency" >&2
    exit 127
  fi
done

tab=$(printf '\t')
busy_mark=$(printf '\033[33m●\033[0m')
done_mark=$(printf '\033[32m✓\033[0m')
idle_mark=$(printf '\033[2m·\033[0m')

# Keep a readable path without letting a deep working directory push the
# useful columns off the screen.
shorten_path() {
  case "$1" in
    "$HOME")
      printf '~'
      ;;
    "$HOME"/*)
      printf '~%s' "${1#"$HOME"}"
      ;;
    *)
      printf '%s' "$1"
      ;;
  esac
}

list_agents() {
  tmux list-panes -a -F \
    "#{pane_id}${tab}#{session_name}${tab}#{window_index}${tab}#{pane_index}${tab}#{window_name}${tab}#{pane_current_command}${tab}#{pane_current_path}${tab}#{@agent_state}${tab}#{@agent_name}${tab}#{pane_tty}" 2>/dev/null |
    while IFS="$tab" read -r pane session win pane_index win_name cmd cwd state agent tty; do
      if [ -z "$agent" ]; then
        case "${cmd##*/}" in
          opencode|codex|claude)
            agent=${cmd##*/}
            ;;
        esac
      fi

      # Some installations run the agent through an interpreter, so inspect
      # the pane's TTY when the foreground command is not conclusive.
      if [ -z "$agent" ] && [ -n "$tty" ]; then
        tty_name=${tty#/dev/}
        # shellcheck disable=SC2009 # pgrep cannot match a macOS tty here.
        if ps -t "$tty_name" -o command= 2>/dev/null |
          grep -qiE '(^|[/ ])(opencode|codex|claude)([/ ]|$)'; then
          agent="agent"
        fi
      fi

      [ -n "$agent" ] || continue

      case "$state" in
        busy) mark=$busy_mark ;;
        done) mark=$done_mark ;;
        *) mark=$idle_mark ;;
      esac

      path=$(shorten_path "$cwd")
      display=$(printf '%s %-8s %s  %s:%s.%s  %s' \
        "$mark" "$agent" "$path" "$session" "$win" "$pane_index" "$win_name")
      printf '%s\t%s\n' "$pane" "$display"
    done
}

rows=$(list_agents)

if [ "${1:-}" = "--list" ]; then
  if [ -n "$rows" ]; then
    printf '%s\n' "$rows"
  fi
  exit 0
fi

if [ -z "$rows" ]; then
  printf 'No agent panes are running.\n'
  sleep 1
  exit 0
fi

selection=$(
  printf '%s\n' "$rows" |
    fzf \
      --ansi \
      --border \
      --layout=reverse \
      --delimiter="$tab" \
      --with-nth=2.. \
      --nth=2.. \
      --prompt='Agent > ' \
      --header='● running   ✓ finished   · unknown   enter: jump   ctrl-r: refresh' \
      --preview='tmux capture-pane -ep -t {1} -S -80' \
      --preview-window='right,60%,wrap' \
      --bind="ctrl-r:reload('$0' --list)"
) || exit 0

[ -n "$selection" ] || exit 0

pane=$(printf '%s\n' "$selection" | cut -f1)
[ -n "$pane" ] || exit 0

session_id=$(tmux display-message -p -t "$pane" '#{session_id}')
window_id=$(tmux display-message -p -t "$pane" '#{window_id}')

tmux switch-client -t "$session_id" 2>/dev/null || true
tmux select-window -t "$window_id"
tmux select-pane -t "$pane"
