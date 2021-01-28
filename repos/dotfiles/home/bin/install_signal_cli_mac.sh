#!/usr/bin/env bash

set -e
set -x

brew install signal-cli

SIGNAL_LIBEXEC_LIBDIR="`brew --prefix signal-cli`/libexec/lib"

# zkgroup-java*.jar --- remove the linux x86_64 bundled lib
zip -d "${SIGNAL_LIBEXEC_LIBDIR}/"zkgroup-java-*.jar libzkgroup.so || true

# download libzkgroup.dylib from
# https://github.com/signalapp/zkgroup/releases

cd /tmp
curl -LO "https://github.com/signalapp/zkgroup/releases/download/v0.7.1/libzkgroup.dylib"

# zkgroup-java*.jar --- bundle the freshly-download mac lib
zip -u "${SIGNAL_LIBEXEC_LIBDIR}/"zkgroup-java-*.jar ./libzkgroup.dylib
