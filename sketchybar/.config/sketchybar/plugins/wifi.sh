#!/bin/bash

# Wi-Fi state without sending any packets: en0 link status, plus whether a
# default route exists. Green: connected, orange: Wi-Fi up but no route,
# red: Wi-Fi down.

source "$CONFIG_DIR/icons.sh"

if [[ "$(ifconfig en0 2>/dev/null)" == *"status: active"* ]]; then
  if route -n get default >/dev/null 2>&1; then
    ICON=$WIFI_CONNECTED COLOR=0xff39FF14
  else
    ICON=$WIFI_DISCONNECTED COLOR=0xffFFA500
  fi
else
  ICON=$WIFI_DISCONNECTED COLOR=0xffFF6B6B
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR icon.align=center
