#!/bin/bash

wifi=(
    script="$PLUGIN_DIR/wifi.sh"
    icon=$WIFI_CONNECTED
    label.drawing=off
    background.color="$PURE_BLACK"
    icon.align=center
    icon.padding_left=0
    icon.padding_right=0
    padding_left=5
    padding_right=0
    background.drawing=off
    icon.color=0xff58d1fc
    update_freq=5
)

sketchybar --add item wifi right \
           --set wifi "${wifi[@]}"
