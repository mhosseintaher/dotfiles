#!/bin/bash

# Open Activity Monitor when network items are clicked
# Switch to Network tab automatically
open -a "Activity Monitor"

# Use AppleScript to switch to Network tab
osascript -e 'tell application "System Events"
    tell process "Activity Monitor"
        set frontmost to true
        delay 0.5
        click menu item "Network" of menu "View" of menu bar 1
    end tell
end tell' 2>/dev/null
