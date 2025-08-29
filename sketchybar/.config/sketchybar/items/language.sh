#!/bin/bash

language=(
    icon="$LANGUAGE"
    icon.font="$FONT:Regular:14.0"
    label.font="$FONT:Medium:14.0"
    padding_left=5
    padding_right=0
    script="$PLUGIN_DIR/language.sh"
    update_freq=0
    updates=when_shown
    click_script="$PLUGIN_DIR/language_click.sh"
)

sketchybar --add item language right \
           --set language "${language[@]}" \
           --subscribe language input_source_changed
