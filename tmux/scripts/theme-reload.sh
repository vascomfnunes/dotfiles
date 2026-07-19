#!/bin/sh
# Reloads the tmux config when the macOS appearance changes, so the theme
# in tmux.conf follows Light/Dark mode. Triggered by a launchd agent that
# watches the global preferences plist, which also changes for unrelated
# settings, so bail out early when the appearance is unchanged.

appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light)
cache_file="$HOME/.cache/tmux-appearance"
radio_theme="$HOME/.cache/pyradio-catppuccin-auto.pyradio-theme"

case $appearance in
  Dark) radio_flavor=mocha ;;
  *) radio_flavor=latte ;;
esac

radio_source="$HOME/.config/pyradio/themes/source/catppuccin-${radio_flavor}.pyradio-theme"
appearance_changed=1
radio_changed=0

if [ -f "$cache_file" ] && [ "$(cat "$cache_file")" = "$appearance" ]; then
  appearance_changed=0
fi

mkdir -p "$HOME/.cache"
if [ -r "$radio_source" ] && ! cmp -s "$radio_source" "$radio_theme"; then
  radio_tmp="${radio_theme}.tmp.$$"
  trap 'rm -f "$radio_tmp"' EXIT HUP INT TERM
  cp "$radio_source" "$radio_tmp"
  mv -f "$radio_tmp" "$radio_theme"
  trap - EXIT HUP INT TERM
  radio_changed=1
fi

if [ "$appearance_changed" -eq 0 ] && [ "$radio_changed" -eq 0 ]; then
  exit 0
fi

printf '%s' "$appearance" > "$cache_file"

# launchd runs with a minimal PATH that excludes Homebrew.
tmux="/opt/homebrew/bin/tmux"
[ -x "$tmux" ] || tmux=$(command -v tmux) || exit 0

"$tmux" has-session 2>/dev/null || exit 0
"$tmux" source-file "$HOME/.config/tmux/tmux.conf"
