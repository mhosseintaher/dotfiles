#!/bin/bash

# The timezone picked in the clock popup (plugins/clock_click.sh) lives in
# a one-line file; no file means the system timezone. Read with a builtin,
# so a tick costs one `date` and one sketchybar call.

source "$CONFIG_DIR/icons.sh"

TZ_FILE="$HOME/.cache/sketchybar/timezone"
SELECTED_TZ=""
[ -r "$TZ_FILE" ] && read -r SELECTED_TZ < "$TZ_FILE"

if [ -n "$SELECTED_TZ" ]; then
    # Other timezone - show white circle only
    TIME_STR=$(TZ="$SELECTED_TZ" date '+%a %d/%m %I:%M %p')
    ICON="●"
else
    # System timezone - show clock icon
    TIME_STR=$(date '+%a %d/%m %I:%M %p')
    ICON="$CLOCK"
fi

sketchybar --set "$NAME" label="$TIME_STR" icon="$ICON" icon.padding_right=4
