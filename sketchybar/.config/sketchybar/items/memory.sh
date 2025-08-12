#!/bin/bash

memory_item=(
  script="$PLUGIN_DIR/memory.sh"
  icon=$MEMORY
  label.drawing=on
  background.color="$PURE_BLACK"
  icon.align=center
  icon.padding_left=8
  icon.padding_right=3
  padding_left=0
  padding_right=0
  background.drawing=off
  update_freq=5
)

sketchybar --add item memory right \
           --set memory "${memory_item[@]}" \
           --subscribe memory system_woke


