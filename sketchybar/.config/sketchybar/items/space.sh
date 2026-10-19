#!/bin/bash

# Define custom labels/icons for your workspaces
SPACE_ICONS=("1" "2" "3" "B" "C" "D" "E" "F" "M" "N" "P" "I" "T" "V" "X")
# background.color=0x44ffffff \

# The highlight follows AeroSpace's exec-on-workspace-change hook
# (aerospace.toml), one batched sketchybar call per switch. Here we only
# set the starting state.
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

space_args=()
for i in "${!SPACE_ICONS[@]}"; do
  id="${SPACE_ICONS[i]}"

  color=$WHITE
  [ "$id" = "$FOCUSED" ] && color=$MAGENTA

  space_item=(
    icon="$id"
    icon.color=$color
    icon.padding_left=7
    icon.padding_right=7
    icon.y_offset=1
    label.drawing=off
    background.color=0xff939ab7
    background.drawing=off
    background.corner_radius=3
    background.padding_left=5
    background.padding_right=5
    background.height=20
    drawing=on
    click_script="aerospace workspace $id"
  )

  space_args+=(--add item space.$id left
               --set space.$id "${space_item[@]}")
done
sketchybar "${space_args[@]}"
