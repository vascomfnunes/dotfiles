#!/bin/bash

LIVEFEED="streamlink -p mpv"

# enable case-insensitive matching
shopt -s nocasematch

url="$1"
case "$url" in
  *youtube.com/watch*|*youtu.be/*|*clips.twitch.tv/*)
    iina --pip $url
    ;;
  *twitch.tv/*)
    $LIVEFEED $url
    ;;
  *reddit.com/r/*)
    rtv --theme ~/.config/rtv/gruvbox -l $url
    ;;
  *i.imgur.com/*.gifv|*i.imgur.com/*.mp4|*i.imgur.com/*.webm|*i.imgur.com/*.gif)
    mpv $url > /dev/null 2>&1 &
    ;;
  *i.imgur.com/*| *imgur.com/*.*)
    $IMAGECLI $url
    ;;
  mailto:*)
    mutt -- $url
    ;;
  *.jpg|*.jpeg|*.png|*:large)
    $IMAGECLI $url
    ;;
  *.gif)
    mpv $url > /dev/null 2>&1 &
    ;;
  *.mp4|*.mkv|*.avi|*.wmv|*.m4v|*.mpg|*.mpeg|*.flv|*.ogm|*.ogv|*.gifv)
    iina --pip $url
    ;;
  *.mp3|*.m4a|*.wav|*.ogg|*.oga|*.flac)
    mpv $url
    ;;
  *|*.html)
    # $DEFAULT "$url"
    open $url
    ;;
esac
