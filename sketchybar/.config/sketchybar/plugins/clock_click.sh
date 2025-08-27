#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Define available timezones
TIMEZONES=(
    "America/New_York:EST (New York)"
    "Asia/Tehran:IRST (Iran)" 
    "Europe/Berlin:CET (Central Europe)"
    "America/Los_Angeles:PST (Los Angeles)"
    "Asia/Tokyo:JST (Tokyo)"
    "Europe/London:GMT (London)"
    "Australia/Sydney:AEST (Sydney)"
)

# Get current system timezone
CURRENT_TZ=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')

toggle_timezones() {
    args=(--remove '/timezone.item\.*/' --set "$NAME" popup.drawing=toggle)
    COUNTER=0
    
    # Get currently selected timezone
    SELECTED_TZ=$(defaults read com.sketchybar.timezone timezone 2>/dev/null || echo "$CURRENT_TZ")
    
    for tz_info in "${TIMEZONES[@]}"; do
        IFS=':' read -r tz_name tz_display <<< "$tz_info"
        
        COLOR=$GREY
        if [ "$tz_name" = "$SELECTED_TZ" ]; then
            COLOR=$WHITE
        fi
        
        args+=(--add item timezone.item.$COUNTER popup."$NAME"
            --set timezone.item.$COUNTER label="$tz_display"
            label.color="$COLOR"
            background.color="$PURE_BLACK"
            background.drawing=on
            background.corner_radius=5
            padding_left=5
            padding_right=5
            click_script="defaults write com.sketchybar.timezone timezone '$tz_name' && sketchybar --set /timezone.item\.*/ label.color=$GREY --set timezone.item.$COUNTER label.color=$WHITE --set $NAME popup.drawing=off --trigger timezone_changed")
        COUNTER=$((COUNTER + 1))
    done
    
    sketchybar -m "${args[@]}" >/dev/null
}

toggle_timezones
