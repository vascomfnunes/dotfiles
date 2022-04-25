#!/bin/bash
read -r cpu a b c previdle rest < /proc/stat
prevtotal=$((a+b+c+previdle))
sleep 0.5
read -r cpu a b c idle rest < /proc/stat
total=$((a+b+c+idle))
cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
icon=""

if [[ "$cpu" -gt 70 ]]; then
    printf "^c#ea6962^%s %s\\n" "$icon" "$cpu%"
else
    printf "^c#a9b665^%s %s\\n" "$icon" "$cpu%"
fi
