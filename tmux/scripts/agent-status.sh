#!/bin/sh

# Record AI agent activity on a tmux pane and surface it in the window name.
# The OpenCode plugin and the Codex/Claude hook adapter call this script; use
# `agent-status clear` to drop a stale marker by hand.
#
# Usage: agent-status <begin|done|clear> [options]

set -eu

PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
export PATH

tab=$(printf '\t')

usage() {
  cat >&2 <<'EOF'
Usage: agent-status <begin|done|clear> [options]

  --agent NAME      Agent label (opencode, codex, claude)
  --pane PANE_ID    tmux pane ID; omit to locate it by command and path
  --path DIR        Working directory used to locate the pane
  --only-done       With clear, only remove a finished marker
  -h, --help        Show this help
EOF
}

action=""
agent=""
pane_opt=""
path=""
only_done=false

while [ $# -gt 0 ]; do
  case "$1" in
    begin|done|clear)
      action="$1"
      ;;
    --agent)
      shift
      agent="${1:-}"
      ;;
    --pane)
      shift
      pane_opt="${1:-}"
      ;;
    --path)
      shift
      path="${1:-}"
      ;;
    --only-done)
      only_done=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage
      exit 1
      ;;
  esac
  shift
done

if [ -z "$action" ]; then
  usage
  exit 1
fi

# Strip a trailing slash so path comparisons below are predictable.
path="${path%/}"

tmux_bin=$(command -v tmux || true)
have_tmux=false
if [ -n "$tmux_bin" ] && "$tmux_bin" list-sessions >/dev/null 2>&1; then
  have_tmux=true
fi

window_option() {
  "$tmux_bin" show-options -wqv -t "$1" "$2" 2>/dev/null || true
}

pane_exists() {
  [ -n "${1:-}" ] || return 1
  [ "$have_tmux" = true ] || return 1
  "$tmux_bin" display-message -p -t "$1" '#{pane_id}' >/dev/null 2>&1
}

# Match the pane's foreground process, falling back to the processes attached
# to its TTY. The fallback catches agents started through an interpreter.
pane_matches_agent() {
  pane_cmd=$1
  pane_tty=$2
  wanted=$3

  case "${pane_cmd##*/}" in
    *"$wanted"*)
      return 0
      ;;
  esac

  [ -n "$pane_tty" ] || return 1
  tty_name=${pane_tty#/dev/}
  [ -n "$tty_name" ] || return 1
  # shellcheck disable=SC2009 # pgrep cannot match a macOS tty here.
  ps -t "$tty_name" -o command= 2>/dev/null | grep -qi -- "$wanted"
}

# Prefer an explicit pane (the hook knows it exactly). Otherwise find the
# agent pane by matching the session directory, then the foreground command.
# The opencode server does not inherit the client's pane, so this heuristic is
# the best information available for sessions started directly.
find_pane() {
  if [ -n "$pane_opt" ]; then
    if pane_exists "$pane_opt"; then
      printf '%s\n' "$pane_opt"
    fi
    return 0
  fi

  [ "$have_tmux" = true ] || return 0
  [ -n "$agent" ] || return 0

  "$tmux_bin" list-panes -a -F \
    "#{pane_id}${tab}#{pane_current_command}${tab}#{pane_current_path}${tab}#{pane_tty}${tab}#{window_active}${tab}#{pane_active}${tab}#{session_attached}" 2>/dev/null |
    while IFS="$tab" read -r id cmd cwd tty win_active pane_active attached; do
      if [ -n "$path" ]; then
        case "$cwd" in
          "$path")
            score=200
            ;;
          "$path"/*)
            score=120
            ;;
          *)
            case "$path" in
              "$cwd"/*)
                score=60
                ;;
              *)
                continue
                ;;
            esac
            ;;
        esac
      else
        score=0
      fi

      pane_matches_agent "$cmd" "$tty" "$agent" || continue

      score=$((score + 20))
      if [ "$win_active" = 1 ]; then
        score=$((score + 6))
      fi
      if [ "$attached" = 1 ]; then
        score=$((score + 3))
      fi
      if [ "$pane_active" = 1 ]; then
        score=$((score + 2))
      fi

      printf '%s\t%s\n' "$score" "$id"
    done |
    sort -rn |
    head -n 1 |
    cut -f 2
}

# Recompute one window's marker from every pane's state. The original name is
# kept in @agent_base so a finished marker can be replaced or removed without
# losing the user's window name.
refresh_window() {
  target=$1
  pane_exists "$target" || return 0

  window=$("$tmux_bin" display-message -p -t "$target" '#{window_id}' 2>/dev/null || true)
  [ -n "$window" ] || return 0

  current=$("$tmux_bin" display-message -p -t "$window" '#{window_name}' 2>/dev/null || true)
  marked=$(window_option "$window" @agent_marked)
  base=$(window_option "$window" @agent_base)

  # Adopt a manual rename as the new base name, dropping any marker the user
  # kept in the new name.
  if [ -z "$base" ] || { [ -n "$marked" ] && [ "$current" != "$marked" ]; }; then
    base=$current
    case "$base" in
      "● "*) base=${base#● } ;;
      "✓ "*) base=${base#✓ } ;;
    esac
    "$tmux_bin" set-option -w -t "$window" @agent_base "$base" >/dev/null
  fi

  states=$("$tmux_bin" list-panes -t "$window" -F '#{@agent_state}' 2>/dev/null || true)
  marker=""
  case "$states" in
    *busy*)
      marker="●"
      ;;
    *done*)
      marker="✓"
      ;;
  esac

  if [ -n "$marker" ]; then
    desired="$marker $base"
  else
    desired="$base"
  fi

  if [ "$desired" != "$current" ]; then
    auto=$(window_option "$window" @agent_auto)
    if [ -z "$auto" ]; then
      auto=$("$tmux_bin" display-message -p -t "$window" '#{automatic-rename}' 2>/dev/null || true)
      [ -n "$auto" ] || auto=0
      "$tmux_bin" set-option -w -t "$window" @agent_auto "$auto" >/dev/null
    fi
    "$tmux_bin" set-window-option -t "$window" automatic-rename off >/dev/null
    "$tmux_bin" rename-window -t "$window" "$desired" >/dev/null
    "$tmux_bin" set-option -w -t "$window" @agent_marked "$desired" >/dev/null
  fi

  if [ -z "$marker" ]; then
    auto=$(window_option "$window" @agent_auto)
    if [ "$auto" = 1 ]; then
      "$tmux_bin" set-window-option -t "$window" automatic-rename on >/dev/null
    fi
    "$tmux_bin" set-option -w -u -t "$window" @agent_base >/dev/null 2>&1 || true
    "$tmux_bin" set-option -w -u -t "$window" @agent_marked >/dev/null 2>&1 || true
    "$tmux_bin" set-option -w -u -t "$window" @agent_auto >/dev/null 2>&1 || true
  fi
}

set_state() {
  target=$1
  state=$2

  pane_exists "$target" || return 0
  "$tmux_bin" set-option -p -t "$target" @agent_state "$state" >/dev/null
  "$tmux_bin" set-option -p -t "$target" @agent_since "$(date +%s)" >/dev/null
  if [ -n "$agent" ]; then
    "$tmux_bin" set-option -p -t "$target" @agent_name "$agent" >/dev/null
  fi
  refresh_window "$target"
}

clear_state() {
  target=$1

  pane_exists "$target" || return 0
  "$tmux_bin" set-option -p -u -t "$target" @agent_state >/dev/null 2>&1 || true
  "$tmux_bin" set-option -p -u -t "$target" @agent_since >/dev/null 2>&1 || true
  "$tmux_bin" set-option -p -u -t "$target" @agent_name >/dev/null 2>&1 || true
  refresh_window "$target"
}

target=$(find_pane)

case "$action" in
  begin)
    if [ -n "$target" ]; then
      set_state "$target" busy
    fi
    ;;
  done)
    if [ -n "$target" ]; then
      set_state "$target" "done"
    fi
    ;;
  clear)
    if [ -n "$target" ]; then
      if [ "$only_done" = true ]; then
        state=$("$tmux_bin" show-options -pqv -t "$target" @agent_state 2>/dev/null || true)
        if [ "$state" = "done" ]; then
          clear_state "$target"
        fi
      else
        clear_state "$target"
      fi
    fi
    ;;
esac
