#!/usr/bin/env bash

source ~/.kiosk_config

arg="$1"

case "$arg" in
    a)
        navigate go "$KIOSK_URL_A"
        ;;
    b)
        navigate go "$KIOSK_URL_B"
        ;;
    c)
        navigate go "$KIOSK_URL_C"
        ;;
    *)
        echo "No URL available for $arg"
        exit 1
        ;;
esac
