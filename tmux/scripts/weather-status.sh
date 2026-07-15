#!/bin/sh
# Prints current weather for the tmux status bar.
# Uses wttr.in and caches the result so tmux does not hit the network every
# status refresh.

set -eu

location="${WEATHER_LOCATION:-Buxton,UK}"
cache_ttl="${WEATHER_CACHE_TTL:-900}"
cache_dir="${TMPDIR:-/tmp}/tmux-weather"
cache_key=$(printf '%s' "$location" | tr -c 'A-Za-z0-9' '_')
cache_file="${cache_dir}/${cache_key}.txt"

mkdir -p "$cache_dir"

mtime() {
  stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null || printf 0
}

now=$(date +%s)
if [ -r "$cache_file" ]; then
  age=$((now - $(mtime "$cache_file")))
  if [ "$age" -lt "$cache_ttl" ]; then
    cat "$cache_file"
    exit 0
  fi
fi

weather=$(curl -fsS --max-time 3 "https://wttr.in/${location}?format=%c+%t&m" 2>/dev/null \
  | tr -d '\r\n')

if [ -n "$weather" ]; then
  printf '%s  ' "$weather" | tee "$cache_file"
elif [ -r "$cache_file" ]; then
  cat "$cache_file"
fi
