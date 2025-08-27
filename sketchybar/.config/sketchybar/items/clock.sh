#!/bin/sh

clock=(
    background.color="$PURE_BLACK"
    update_freq=10
    icon=$CLOCK
    script="$PLUGIN_DIR/clock.sh"
    click_script="$PLUGIN_DIR/clock_click.sh"
    popup.align=right
    popup.height=35
)

sketchybar --add item clock right \
           --set clock "${clock[@]}" \
           --subscribe clock timezone_changed