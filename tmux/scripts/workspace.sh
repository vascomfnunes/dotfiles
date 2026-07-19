#!/bin/sh

# Reattach the main tmux session when it is alive; otherwise rebuild the
# session's windows, panes, working directories, and applications.

set -eu

session="${USER:-main}"
project="$HOME"
workspace_config="$HOME/.tmux-workspace.local"

if [ -r "$workspace_config" ]; then
  # This file is intentionally local so machine- or work-specific paths do not
  # need to be committed to the dotfiles repository.
  # shellcheck source=/dev/null
  . "$workspace_config"
fi

session="${TMUX_WORKSPACE_SESSION:-$session}"
project="${TMUX_WORKSPACE_PROJECT:-$project}"

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

start_app() {
  target="$1"
  app="$2"

  # Start applications through an interactive shell so aliases, functions,
  # mise, and the rest of the normal zsh environment are available.
  "$tmux_bin" send-keys -t "$target" -l "$app"
  "$tmux_bin" send-keys -t "$target" Enter
}

if "$tmux_bin" has-session -t "=$session" 2>/dev/null; then
  attach_session
  exit 0
fi

# Window 1: a plain zsh shell on the left (roughly 80/20); the right column
# holds the radio cover art pane on top of PyRadio.
session_id="$($tmux_bin new-session -d -P -F '#{session_id}' \
  -s "$session" -n zsh -c "$HOME")"

"$tmux_bin" split-window -d -h -l '21%' \
  -t "${session_id}:zsh.1" -c "$HOME"
start_app "${session_id}:zsh.2" pyradio
"$tmux_bin" split-window -d -vb -l 15 -t "${session_id}:zsh.2" \
  "$HOME/.local/bin/tmux-pyradio-art"

# Window 2: Neovim in the configured project directory.
"$tmux_bin" new-window -d -t "${session_id}:" \
  -n nvim -c "$project"
start_app "${session_id}:nvim.1" nvim

# Match the currently selected window and pane.
"$tmux_bin" select-window -t "${session_id}:zsh"
"$tmux_bin" select-pane -t "${session_id}:zsh.1"

attach_session
