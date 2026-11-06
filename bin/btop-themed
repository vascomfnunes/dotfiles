#!/bin/sh
# Launches btop with the Catppuccin flavor matching the macOS appearance.
# The selected flavor is written to btop's normal config so changes made from
# btop's Options screen continue to persist.

set -eu

btop_bin=$(command -v btop) || {
  echo "btop is not installed" >&2
  exit 127
}

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/btop"
config_file="$config_dir/btop.conf"

mkdir -p "$config_dir"
if [ ! -f "$config_file" ]; then
  "$btop_bin" --default-config > "$config_file"
fi

if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
  theme=catppuccin_mocha
else
  theme=catppuccin_latte
fi

current_theme=$(sed -n 's/^color_theme = "\([^"]*\)"/\1/p' "$config_file" | head -n 1)
if [ "$current_theme" != "$theme" ]; then
  config_tmp=$(mktemp "${config_file}.tmp.XXXXXX")
  trap 'rm -f "$config_tmp"' EXIT HUP INT TERM
  awk -v theme="$theme" '
    BEGIN { replaced = 0 }
    /^color_theme = / {
      print "color_theme = \"" theme "\""
      replaced = 1
      next
    }
    { print }
    END {
      if (!replaced) print "color_theme = \"" theme "\""
    }
  ' "$config_file" > "$config_tmp"
  mv -f "$config_tmp" "$config_file"
  trap - EXIT HUP INT TERM
fi

exec "$btop_bin" "$@"
