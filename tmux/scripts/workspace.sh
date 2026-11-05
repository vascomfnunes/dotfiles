#!/bin/sh

# Reattach the main tmux session when it is alive; otherwise rebuild the
# session's windows, panes, working directories, and applications.

set -eu

session="${USER:-main}"
project="$HOME"
workspace_config="$HOME/.tmux-workspace.local"

if [ "${1:-}" = --radio ]; then
  tmux_bin="$(command -v tmux)"
  radio_session="dotfiles-radio-${USER:-main}"
  if ! "$tmux_bin" has-session -t "=$radio_session" 2>/dev/null; then
    radio_pane=$("$tmux_bin" new-session -d -P -F '#{pane_id}' -s "$radio_session" -n radio \
      "$HOME/.local/bin/tmux-radio-player; tmux kill-session -t '=$radio_session'"
    )
    "$tmux_bin" split-window -d -vb -l 15 -t "=$radio_session:radio" \
      "$HOME/.local/bin/tmux-radio-art"
    "$tmux_bin" select-pane -t "$radio_pane"
  fi
  "$tmux_bin" set-option -t "$radio_session" status off
  unset TMUX
  exec "$tmux_bin" attach-session -t "=$radio_session"
fi

if [ -r "$workspace_config" ]; then
  # This file is intentionally local so machine- or work-specific paths do not
  # need to be committed to the dotfiles repository.
  # shellcheck source=/dev/null
  . "$workspace_config"
fi

session="${TMUX_WORKSPACE_SESSION:-$session}"
project="${TMUX_WORKSPACE_PROJECT:-$project}"
nvim_server="${NVIM_SERVER:-${TMPDIR:-/tmp}/nvim-${USER:-$(id -u)}.sock}"

if [ ! -d "$project" ]; then
  echo "Configured tmux workspace project does not exist: $project" >&2
  echo "Falling back to $HOME" >&2
  project="$HOME"
fi

tmux_bin="$(command -v tmux)"

attach_session() {
  if [ -n "${TMUX:-}" ]; then
    "$tmux_bin" switch-client -t "=$session"
  else
    exec "$tmux_bin" attach-session -t "=$session"
  fi
}

if "$tmux_bin" has-session -t "=$session" 2>/dev/null; then
  # Preserve the panes and layout of an already-running workspace.
  attach_session
  exit 0
fi

# Window 1: a zsh shell in the home directory.
session_info="$($tmux_bin new-session -d -P -F '#{session_id} #{window_id} #{pane_id}' \
  -s "$session" -n zsh -c "$HOME")"
session_id="${session_info%% *}"
first_window="${session_info#* }"
first_window="${first_window%% *}"
shell_pane="${session_info##* }"

# Start the applications in interactive shells so the normal environment is loaded.
"$tmux_bin" new-window -d -t "${session_id}:" -n nvim -c "$project"
if nvim --server "$nvim_server" --remote-expr '1' >/dev/null 2>&1; then
  "$tmux_bin" send-keys -t "${session_id}:nvim" -l nvim
else
  quoted_server=$(printf '%s' "$nvim_server" | sed "s/'/'\\\\''/g")
  "$tmux_bin" send-keys -t "${session_id}:nvim" -l "nvim --listen '$quoted_server'"
fi
"$tmux_bin" send-keys -t "${session_id}:nvim" Enter

"$tmux_bin" new-window -d -t "${session_id}:" -n opencode -c "$project"
"$tmux_bin" send-keys -t "${session_id}:opencode" -l opencode
"$tmux_bin" send-keys -t "${session_id}:opencode" Enter

# Match the currently selected window and pane.
"$tmux_bin" select-window -t "$first_window"
"$tmux_bin" select-pane -t "$shell_pane"

attach_session
