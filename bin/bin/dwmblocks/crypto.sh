#!/usr/bin/env bash

# This plugin uses the Coingecko public API: https://www.coingecko.com/en/api

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CRYPTO_CURRENCY='usd'
CRYPTO_CURRENCY_SYMBOL='$'
CRYPTO_ID='basic-attention-token'
CRYPTO_CACHE_SECONDS=300
CRYPTO_ICON=' '
CRYPTO_ICON_HIDE='false'

cache_file=/tmp/crypto
cache_ttl=$CRYPTO_CACHE_SECONDS

if [[ $CRYPTO_ICON_HIDE == 'true' ]]; then
    ICON=''
else
    ICON=$CRYPTO_ICON
fi

if [[ -f "$cache_file" ]]; then
    NOW=$(date +%s)
    MOD=$(date -r "$cache_file" +%s)
    if [[ $(( $NOW - $MOD )) -gt $cache_ttl ]]; then
        rm "$cache_file"
    fi
fi

if [[ ! -f "$cache_file" ]]; then
    RESPONSE=$(curl --silent -X 'GET' https://api.coingecko.com/api/v3/coins/markets?vs_currency=${CRYPTO_CURRENCY}\&ids=${CRYPTO_ID})

    PRICE=$(echo "$RESPONSE" | jq '.[].current_price')
    echo "^c#d3869b^${ICON}${PRICE}${CRYPTO_CURRENCY_SYMBOL}" >"$cache_file"
fi

cat "$cache_file"
