#!/bin/sh

# Reattach the main tmux session when it is alive; otherwise rebuild the
# session's windows, panes, working directories, and applications.

set -eu

session="${USER:-main}"
project="$HOME"
radio_width="20%"
radio_art_height=20
workspace_config="$HOME/.tmux-workspace.local"

if [ -r "$workspace_config" ]; then
  # This file is intentionally local so machine- or work-specific paths do not
  # need to be committed to the dotfiles repository.
  # shellcheck source=/dev/null
  . "$workspace_config"
fi

session="${TMUX_WORKSPACE_SESSION:-$session}"
project="${TMUX_WORKSPACE_PROJECT:-$project}"
radio_width="${TMUX_WORKSPACE_RADIO_WIDTH:-$radio_width}"
radio_art_height="${TMUX_WORKSPACE_RADIO_ART_HEIGHT:-$radio_art_height}"

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

set_radio_geometry() {
  target="$1"

  # A detached session starts at tmux's fallback size. When a real client is
  # attached, tmux distributes the added rows and columns across the layout.
  # Reapply the intended dimensions after every window resize.
  "$tmux_bin" resize-pane -t "$target" -x "$radio_width" || return 1
  "$tmux_bin" resize-pane -t "$target" -y "$radio_art_height" || return 1
  "$tmux_bin" set-hook -w -t "$target" window-resized \
    "resize-pane -t '$target' -x '$radio_width' ; resize-pane -t '$target' -y '$radio_art_height'"
}

if "$tmux_bin" has-session -t "=$session" 2>/dev/null; then
  # Also apply configuration changes to an already-running workspace.
  set_radio_geometry "=$session:zsh.2" 2>/dev/null || true
  attach_session
  exit 0
fi

# Window 1: a plain zsh shell on the left; the narrow right column holds the
# radio cover art pane on top of PyRadio.
session_id="$($tmux_bin new-session -d -P -F '#{session_id}' \
  -s "$session" -n zsh -c "$HOME")"

radio_pane="$($tmux_bin split-window -d -h -l "$radio_width" -P \
  -F '#{pane_id}' -t "${session_id}:zsh.1" -c "$HOME")"
start_app "$radio_pane" pyradio
art_pane="$($tmux_bin split-window -d -vb -l "$radio_art_height" -P \
  -F '#{pane_id}' -t "$radio_pane" "$HOME/.local/bin/tmux-pyradio-art")"
set_radio_geometry "$art_pane"

# Window 2: Neovim in the configured project directory.
"$tmux_bin" new-window -d -t "${session_id}:" \
  -n nvim -c "$project"
start_app "${session_id}:nvim.1" nvim

# Match the currently selected window and pane.
"$tmux_bin" select-window -t "${session_id}:zsh"
"$tmux_bin" select-pane -t "${session_id}:zsh.1"

attach_session
