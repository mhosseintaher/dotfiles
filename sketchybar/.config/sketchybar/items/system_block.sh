#!/bin/bash

source "$ITEM_DIR/cpu.sh"
source "$ITEM_DIR/memory.sh"
source "$ITEM_DIR/network.sh"

system_block=(
  background.color="$PURE_BLACK"
  background.corner_radius=6
  background.padding_left=0
  background.padding_right=0
  blur_radius=0
)

sketchybar --add bracket system_block cpu memory net_down net_up \
           --set system_block "${system_block[@]}"


