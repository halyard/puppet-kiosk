#!/usr/bin/env bash

arg="$1"

case "$arg" in
    a)
        navigate "$KIOSK_URL_A"
        ;;
    b)
        navigate "$KIOSK_URL_B"
        ;;
    c)
        navigate "$KIOSK_URL_C"
        ;;
    *)
        echo "No URL available for $arg"
        exit 1
        ;;
esac
