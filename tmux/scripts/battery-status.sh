#!/bin/sh
# Prints the Mac's battery charge for the tmux status bar.
# Uses pmset, which ships with macOS, and prints nothing when no battery exists.

# Catppuccin Mocha fallbacks; tmux passes the matching Mocha or Latte palette.
charging_color=${1:-#94e2d5}
high_color=${2:-#a6e3a1}
medium_color=${3:-#f9e2af}
low_color=${4:-#f38ba8}

battery_status=$(pmset -g batt 2>/dev/null) || exit 0
percentage=$(printf '%s\n' "$battery_status" | sed -n 's/.*[[:space:]]\([0-9][0-9]*\)%;.*/\1/p' | head -n 1)

[ -n "$percentage" ] || exit 0

case $battery_status in
  *"; charging;"*)
    icon='󰂄'
    color=$charging_color
    ;;
  *)
    if [ "$percentage" -le 10 ]; then
      icon=''
    elif [ "$percentage" -le 25 ]; then
      icon=''
    elif [ "$percentage" -le 50 ]; then
      icon=''
    elif [ "$percentage" -le 75 ]; then
      icon=''
    else
      icon=''
    fi

    if [ "$percentage" -le 20 ]; then
      color=$low_color
    elif [ "$percentage" -le 50 ]; then
      color=$medium_color
    else
      color=$high_color
    fi
    ;;
esac

printf '#[fg=%s]%s %s%%#[default]  ' "$color" "$icon" "$percentage"
