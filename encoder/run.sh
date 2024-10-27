#!/bin/sh

# Check for source and encoder URL's

if [ -z "${ENC_SOURCE}" ]; then
    echo "Source stream has not been set - unable to continue"
    exit 1
else
    SOURCE="${ENC_SOURCE}"
fi

if [ -z "${ENC_MUX}" ]; then
    echo "Multiplexer URL has not been set - unable to continue"
    exit 2
else
    MUX="${ENC_MUX}"
fi

# Set DAB or DAB+ encoding

if [ -z "${ENC_DABPLUS}" ]; then
    DABPLUS=true
else
    DABPLUS="${ENC_DABPLUS}"
fi

if [ $DABPLUS = false ]; then
    DABFLAG="-a"
fi

# Set encoder settings

if [ -z "${ENC_GAIN}" ]; then
    GAIN=0
else
    GAIN="${ENC_GAIN}"
fi

if [ -z "${ENC_BITRATE}" ]; then
    BITRATE=128
else
    BITRATE="${ENC_BITRATE}"
fi

if [ -z "${ENC_CHANNELS}" ]; then
    CHANNELS=2
else
    CHANNELS="${ENC_CHANNELS}"
fi

if [ -z "${ENC_SAMPLERATE}" ]; then
    SAMPLERATE=2
else
    SAMPLERATE="${ENC_SAMPLERATE}"
fi

# Run encoder

exec odr-audioenc -v $SOURCE -g $GAIN $DABFLAG -b $BITRATE -c $CHANNELS -r $SAMPLERATE -T 0 -e $MUX "$@"
