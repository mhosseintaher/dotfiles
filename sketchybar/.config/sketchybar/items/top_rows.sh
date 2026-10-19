#!/bin/bash

# Pre-creates the popup rows of a stats item once ($1 = cpu | memory):
# a header plus 10 process rows. plugins/top_popup.sh only fills the labels.
# Clicking a row opens Activity Monitor.

top_row=(
  icon.drawing=off
  background.drawing=off
  label.font="$FONT:Regular:13.0"
  label.color=$WHITE
  label.padding_left=10
  label.padding_right=10
  padding_left=0
  padding_right=0
  click_script="sketchybar --set $1 popup.drawing=off; open -a 'Activity Monitor'"
)

top_args=(--add item "$1.top.h" "popup.$1"
          --set "$1.top.h" "${top_row[@]}" label.color=$GREY
                label="$(printf '%-24s %6s %6s' PROCESS CPU MEM)")
for i in 0 1 2 3 4 5 6 7 8 9; do
  top_args+=(--add item "$1.top.$i" "popup.$1"
             --set "$1.top.$i" "${top_row[@]}")
done
sketchybar "${top_args[@]}"
