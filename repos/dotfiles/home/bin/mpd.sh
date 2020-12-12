#!/usr/bin/env bash

PLAYING=$(mpc current)

if [[ ! -z "$PLAYING" ]]; then
    echo ' ' "$PLAYING"
    exit
else
    echo ""
fi
