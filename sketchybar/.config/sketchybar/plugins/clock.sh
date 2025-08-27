#!/bin/bash

source "$CONFIG_DIR/icons.sh"

# Get current system timezone
SYSTEM_TZ=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')

# Get selected timezone (default to system timezone)
SELECTED_TZ=$(defaults read com.sketchybar.timezone timezone 2>/dev/null || echo "$SYSTEM_TZ")

# Generate time for selected timezone
TIME_STR=$(TZ="$SELECTED_TZ" date '+%a %d/%m %I:%M %p')

if [ "$SELECTED_TZ" = "$SYSTEM_TZ" ]; then
    # Same as system timezone - show clock icon
    sketchybar --set "$NAME" label="$TIME_STR" icon="$CLOCK" icon.padding_right=4
else
    # Different timezone - show white circle only
    sketchybar --set "$NAME" label="$TIME_STR" icon="●" icon.padding_right=4
fi