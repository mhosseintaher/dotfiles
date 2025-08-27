#!/bin/bash

source "$CONFIG_DIR/icons.sh"

# Check WiFi status using multiple methods for accuracy
WIFI_STATUS=$(ifconfig en0 | grep "status:" | cut -d: -f2 | sed 's/^ *//')
SSID=$(networksetup -getairportnetwork en0 2>/dev/null | cut -d: -f2- | sed 's/^ *//')

# Also check via scutil for SSID
if [[ -z "$SSID" || "$SSID" == *"not associated"* ]]; then
  SSID_ALT=$(echo "show State:/Network/Interface/en0/AirPort" | scutil | grep "SSID_STR" | cut -d: -f2 | sed 's/^ *//')
  if [[ -n "$SSID_ALT" && "$SSID_ALT" != "" ]]; then
    SSID="$SSID_ALT"
  fi
fi

# Check if WiFi interface is active and we have connectivity
if [[ "$WIFI_STATUS" == "active" ]]; then
  # WiFi interface is active - check if we have internet
  if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    # We have internet connectivity
    if [[ -n "$SSID" && "$SSID" != *"not associated"* && "$SSID" != "" ]]; then
      # WiFi is connected with known SSID - show green
      sketchybar --set wifi \
        icon="$WIFI_CONNECTED" \
        icon.color=0xff39FF14 \
        icon.align=center \
        label="$SSID"
    else
      # WiFi is connected but SSID unknown - show green with generic label
      sketchybar --set wifi \
        icon="$WIFI_CONNECTED" \
        icon.color=0xff39FF14 \
        icon.align=center \
        label="Connected"
    fi
  else
    # WiFi interface active but no internet - show yellow
    sketchybar --set wifi \
      icon="$WIFI_DISCONNECTED" \
      icon.color=0xffFFA500 \
      icon.align=center \
      label="No Internet"
  fi
else
  # WiFi interface is not active - show red
  sketchybar --set wifi \
    icon="$WIFI_DISCONNECTED" \
    icon.color=0xffFF6B6B \
    icon.align=center \
    label="Disconnected"
fi