#!/bin/bash

# Get list of available input sources
INPUT_SOURCES=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleEnabledInputSources | \
    plutil -convert xml1 - -o - | \
    grep -A1 "KeyboardLayout Name\|InputSourceID" | \
    grep "<string>" | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//')

# If we have multiple input sources, cycle through them
if [ "$(echo "$INPUT_SOURCES" | wc -l)" -gt 1 ]; then
    # Open System Preferences to Input Sources (this is the most reliable way to switch)
    open "x-apple.systempreferences:com.apple.preference.keyboard?Text"
else
    # If only one input source, open Language & Region preferences
    open "x-apple.systempreferences:com.apple.Localization.plist"
fi
