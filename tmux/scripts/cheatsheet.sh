#!/bin/sh
# Browse cht.sh topics with fzf and open a query in a color-aware pager.

set -eu

for dependency in curl fzf jq less; do
  if ! command -v "$dependency" >/dev/null 2>&1; then
    printf '%s is not installed\n' "$dependency" >&2
    exit 127
  fi
done

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/tmux-cheatsheet"
topics_file="$cache_dir/topics"
mkdir -p "$cache_dir"

# Refresh the topic index daily. If cht.sh is temporarily unavailable, keep
# using a previously downloaded index.
refresh_topics=false
if [ ! -s "$topics_file" ]; then
  refresh_topics=true
elif [ -n "$(find "$topics_file" -mtime +0 -print -quit)" ]; then
  refresh_topics=true
fi

if [ "$refresh_topics" = true ]; then
  topics_tmp=$(mktemp "$cache_dir/topics.XXXXXX")
  trap 'rm -f "$topics_tmp"' EXIT HUP INT TERM
  if curl --fail --silent --show-error --location --max-time 15 \
      https://cht.sh/:list > "$topics_tmp"; then
    mv -f "$topics_tmp" "$topics_file"
    trap - EXIT HUP INT TERM
  elif [ ! -s "$topics_file" ]; then
    exit 1
  fi
fi

topic=$(
  fzf \
    --ansi \
    --border \
    --layout=reverse \
    --prompt='Cheatsheet > ' \
    --preview='curl --fail --silent --location --max-time 8 https://cht.sh/{} 2>/dev/null' \
    --preview-window='right,60%,wrap' \
    < "$topics_file"
) || exit 0

# Topics come from cht.sh, but keep the value safe before placing it in a URL
# used by fzf's shell preview and curl.
case "$topic" in
  *[!A-Za-z0-9_+./~-]*)
    printf 'Unexpected topic name: %s\n' "$topic" >&2
    exit 1
    ;;
esac

printf 'Query for %s (optional): ' "$topic"
IFS= read -r query || exit 0

url="https://cht.sh/$topic"
if [ -n "$query" ]; then
  encoded_query=$(printf '%s' "$query" | jq -sRr @uri)
  url="$url/$encoded_query"
fi

result_tmp=$(mktemp "$cache_dir/result.XXXXXX")
trap 'rm -f "$result_tmp"' EXIT HUP INT TERM
curl --fail --silent --show-error --location --globoff --max-time 30 \
  "$url" > "$result_tmp"
less -R "$result_tmp"
