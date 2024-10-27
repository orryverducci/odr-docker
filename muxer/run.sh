#!/bin/sh

if [ -z "${MUX_CONF}" ]; then
    CONF_FILE="/data/configuration.mux"
else
    CONF_FILE="${MUX_CONF}"
fi

exec odr-dabmux $CONF_FILE "$@"
