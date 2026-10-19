#!/bin/bash

# The label is pushed by helpers/sb_stats (started in sketchybarrc), so this
# item has no polling script. The script only drives the click popup.
memory_item=(
  script="$PLUGIN_DIR/top_popup.sh"
  icon=$MEMORY
  label="--%"
  label.drawing=on
  background.color="$PURE_BLACK"
  icon.align=center
  icon.padding_left=8
  icon.padding_right=3
  padding_left=0
  padding_right=0
  background.drawing=off
  update_freq=0
  updates=when_shown
  popup.align=right
  popup.background.color="$PURE_BLACK"
  popup.background.corner_radius=6
  popup.background.border_color="$BACKGROUND_2"
  popup.background.border_width=1
)

sketchybar --add item memory right \
           --set memory "${memory_item[@]}" \
           --subscribe memory mouse.clicked mouse.exited.global

source "$ITEM_DIR/top_rows.sh" memory
