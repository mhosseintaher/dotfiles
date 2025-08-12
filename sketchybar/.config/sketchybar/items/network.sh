#!/bin/bash

net_down_item=(
  script="$PLUGIN_DIR/network.sh"
  icon=$NET_DOWN
  icon.drawing=on
  label.drawing=on
  background.color="$PURE_BLACK"
  icon.align=center
  icon.padding_left=3
  icon.padding_right=3
  padding_left=5
  padding_right=0
  background.drawing=off
  update_freq=2
)

net_up_item=(
  script="$PLUGIN_DIR/network.sh"
  icon=$NET_UP
  icon.drawing=on
  label.drawing=on
  background.color="$PURE_BLACK"
  icon.align=center
  icon.padding_left=3
  icon.padding_right=3
  padding_left=10
  padding_right=0
  background.drawing=off
  update_freq=2
)

sketchybar --add item net_down right \
           --set net_down "${net_down_item[@]}" \
           --subscribe net_down system_woke

sketchybar --add item net_up right \
           --set net_up "${net_up_item[@]}" \
           --subscribe net_up system_woke

