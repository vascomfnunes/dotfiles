#!/bin/sh
# Reloads the tmux config when the macOS appearance changes, so the theme
# in tmux.conf follows Light/Dark mode. Triggered by a launchd agent that
# watches the global preferences plist, which also changes for unrelated
# settings, so bail out early when the appearance is unchanged.

appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light)
cache_file="$HOME/.cache/tmux-appearance"

if [ -f "$cache_file" ] && [ "$(cat "$cache_file")" = "$appearance" ]; then
  exit 0
fi

mkdir -p "$HOME/.cache"
printf '%s' "$appearance" > "$cache_file"

# launchd runs with a minimal PATH that excludes Homebrew.
tmux="/opt/homebrew/bin/tmux"
[ -x "$tmux" ] || tmux=$(command -v tmux) || exit 0

"$tmux" has-session 2>/dev/null || exit 0
"$tmux" source-file "$HOME/.config/tmux/tmux.conf"
