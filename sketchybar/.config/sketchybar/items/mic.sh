#!/bin/bash

mic=(
  update_freq=3
  script="$PLUGIN_DIR/mic.sh"
  click_script="$PLUGIN_DIR/mic_click.sh"
  label.drawing=off
  icon.align=center
  icon.padding_left=5
  icon.padding_right=5
  padding_left=5
  padding_right=5
  background.color="$PURE_BLACK"
  background.drawing=off
)

sketchybar --add item mic right \
           --set mic "${mic[@]}" \
           --subscribe mic volume_change
