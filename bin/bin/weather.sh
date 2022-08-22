#!/bin/bash

# Weather data reference: http://openweathermap.org/weather-conditions
icon() {
    case $1 in
        # Thunderstorm group
        200|201|202|210|211|212|221|230|231|232) echo ' '
            ;;
        # Drizzle group
        300|301|302|310|311|312|313|314|321) echo '歹'
            ;;
        # Rain group
        500|501) echo '歹'
            ;;
        502|503|504) echo '殺'
            ;;
        511) echo '晴'
            ;;
        520|521|522|531) echo '歹'
            ;;
        # Snow group
        600|601|602|611|612|613|615|616|620|621|622) echo '流'
            ;;
        # Atmosphere group
        701|711|721|731|741|751|761|762|771|781) echo '敖'
            ;;
        # Clear group
        800) echo '滛'
            ;;
        # Clouds group
        801) echo '杖'
            ;;
        802) echo '摒'
            ;;
        803) echo '摒'
            ;;
        804) echo '摒'
            ;;
        *) echo "$1"
    esac
}

cache_file=$HOME/.weather

LOCATION=$(curl --silent http://ip-api.com/csv)
LAT=$(echo "$LOCATION" | cut -d , -f 8)
LON=$(echo "$LOCATION" | cut -d , -f 9)
WEATHER=$(/usr/bin/curl --silent http://api.openweathermap.org/data/2.5/weather\?lat="$LAT"\&lon="$LON"\&APPID="$OPEN_WEATHER_API_KEY"\&units=metric)
CATEGORY=$(echo "$WEATHER" | jq .weather[0].id)
TEMP="$(echo "$WEATHER" | jq .main.temp | cut -d . -f 1)"
ICON=$(icon "$CATEGORY")

echo "${ICON}  ${TEMP}" >"$cache_file"
