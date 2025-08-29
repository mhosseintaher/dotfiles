#!/bin/bash

# Monitor for input source changes and trigger sketchybar event
# This script runs in the background and watches for changes

LAST_LANGUAGE=""

while true; do
    # Get current input source using the same method as the main script
    CURRENT_LANGUAGE=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | \
        plutil -convert xml1 - -o - | \
        grep -A1 "KeyboardLayout Name" | \
        grep "<string>" | \
        sed 's/<[^>]*>//g' | \
        sed 's/^[[:space:]]*//' | \
        head -1)

    # If the above doesn't work, try alternative method
    if [ -z "$CURRENT_LANGUAGE" ]; then
        CURRENT_LANGUAGE=$(defaults read com.apple.HIToolbox AppleSelectedInputSources | \
            grep "InputSourceID" | \
            head -1 | \
            sed 's/.*"\(.*\)".*/\1/' | \
            sed 's/.*\.//')
    fi

    # Default fallback
    if [ -z "$CURRENT_LANGUAGE" ]; then
        CURRENT_LANGUAGE="EN"
    fi

    # Check if language changed
    if [ "$CURRENT_LANGUAGE" != "$LAST_LANGUAGE" ] && [ -n "$LAST_LANGUAGE" ]; then
        # Trigger sketchybar event
        sketchybar --trigger input_source_changed
    fi

    LAST_LANGUAGE="$CURRENT_LANGUAGE"
    
    # Check every 0.5 seconds for responsive updates
    sleep 0.5
done
