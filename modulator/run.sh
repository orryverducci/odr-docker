#!/bin/sh

if [ -z "${MOD_CONF}" ]; then
    CONF_FILE="/data/configuration.ini"
else
    CONF_FILE="${MOD_CONF}"
fi

if [ -z "${MOD_RTLTCP}" ]; then
    RTLTCP=false
else
    RTLTCP="${MOD_RTLTCP}"
fi

if [ $RTLTCP = true ]; then
    exec odr-dabmod $CONF_FILE "$@" | node /server.mjs
else
    exec odr-dabmod $CONF_FILE "$@"
fi

