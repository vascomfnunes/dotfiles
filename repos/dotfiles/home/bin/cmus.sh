#!/usr/bin/env bash

ARTIST=$( cmus-remote -Q 2>/dev/null | grep artist | cut -d " " -f 3- )
TITLE=$( cmus-remote -Q 2>/dev/null | grep title | cut -d " " -f 3- )

if [[ ! -z "$ARTIST" ]]; then
    TRACK_LEN=${#TITLE}
    if [[ "$TRACK_LEN" -gt 30 ]]; then
        TITLE=`echo "$TITLE" | cut -c -30`
        TITLE+=...
    fi

    ARTIST_LEN=${#ARTIST}
    if [[ "$ARTIST_LEN" -gt 20 ]]; then
        ARTIST=`echo "$ARTIST" | cut -c -20`
        ARTIST+=...
    fi

    echo ' ' "$ARTIST" - "$TITLE "
    exit
else
    echo ""
fi
