#!/bin/bash

cpu_item=(
  script="$PLUGIN_DIR/cpu.sh"
  icon=$CPU
  label.drawing=on
  background.color="$PURE_BLACK"
  icon.align=center
  icon.padding_left=8
  icon.padding_right=3
  padding_left=0
  padding_right=0
  background.drawing=off
  update_freq=2
)

sketchybar --add item cpu right \
           --set cpu "${cpu_item[@]}" \
           --subscribe cpu system_woke


