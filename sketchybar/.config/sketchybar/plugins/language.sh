#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get current input source
CURRENT_LANGUAGE=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | \
    plutil -convert xml1 - -o - | \
    grep -A1 "KeyboardLayout Name" | \
    grep "<string>" | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//' | \
    head -1)

# If the above doesn't work, try alternative method
if [ -z "$CURRENT_LANGUAGE" ]; then
    CURRENT_LANGUAGE=$(osascript -e 'tell application "System Events" to tell process "SystemUIServer" to get the name of the first menu bar item of menu bar 1 whose description contains "input source"' 2>/dev/null)
fi

# If still empty, try getting the language directly from system preferences
if [ -z "$CURRENT_LANGUAGE" ]; then
    CURRENT_LANGUAGE=$(defaults read com.apple.HIToolbox AppleSelectedInputSources | \
        grep "InputSourceID" | \
        head -1 | \
        sed 's/.*"\(.*\)".*/\1/' | \
        sed 's/.*\.//')
fi

# Default fallback and cleanup
if [ -z "$CURRENT_LANGUAGE" ]; then
    CURRENT_LANGUAGE="EN"
else
    # Clean up and shorten common language names
    case "$CURRENT_LANGUAGE" in
        *"U.S."*|*"US"*|*"American"*|*"English"*)
            CURRENT_LANGUAGE="EN"
            ;;
        *"Spanish"*|*"Español"*)
            CURRENT_LANGUAGE="ES"
            ;;
        *"French"*|*"Français"*)
            CURRENT_LANGUAGE="FR"
            ;;
        *"German"*|*"Deutsch"*)
            CURRENT_LANGUAGE="DE"
            ;;
        *"Italian"*|*"Italiano"*)
            CURRENT_LANGUAGE="IT"
            ;;
        *"Portuguese"*|*"Português"*)
            CURRENT_LANGUAGE="PT"
            ;;
        *"Russian"*|*"Русский"*)
            CURRENT_LANGUAGE="RU"
            ;;
        *"Japanese"*|*"日本語"*)
            CURRENT_LANGUAGE="JP"
            ;;
        *"Chinese"*|*"中文"*)
            CURRENT_LANGUAGE="CN"
            ;;
        *"Korean"*|*"한국어"*)
            CURRENT_LANGUAGE="KR"
            ;;
        *"Arabic"*|*"العربية"*)
            CURRENT_LANGUAGE="AR"
            ;;
        *)
            # Take first 2-3 characters if it's a longer name
            CURRENT_LANGUAGE=$(echo "$CURRENT_LANGUAGE" | cut -c1-3 | tr '[:lower:]' '[:upper:]')
            ;;
    esac
fi

# Set color based on language (optional customization)
case "$CURRENT_LANGUAGE" in
    "EN")
        COLOR="$BLUE"
        ;;
    "ES")
        COLOR="$ORANGE"
        ;;
    "FR")
        COLOR="$MAGENTA"
        ;;
    *)
        COLOR="$WHITE"
        ;;
esac

sketchybar --set "$NAME" label="$CURRENT_LANGUAGE" \
                         icon.color="$COLOR" \
                         label.color="$COLOR"
