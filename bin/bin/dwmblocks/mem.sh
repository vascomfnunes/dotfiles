#!/usr/bin/env bash

echo "^c#7daea3^ $(free -h | awk '/^Mem/ { print $3"/"$2 }' | sed s/i//g)"
