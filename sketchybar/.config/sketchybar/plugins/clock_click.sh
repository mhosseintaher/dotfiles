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
TZ_FILE="$HOME/.cache/sketchybar/timezone"

toggle_timezones() {
    args=(--remove '/timezone.item\.*/' --set "$NAME" popup.drawing=toggle)
    COUNTER=0
    
    # Get currently selected timezone (no file = system timezone)
    SELECTED_TZ=""
    [ -r "$TZ_FILE" ] && read -r SELECTED_TZ < "$TZ_FILE"
    : "${SELECTED_TZ:=$CURRENT_TZ}"
    
    for tz_info in "${TIMEZONES[@]}"; do
        IFS=':' read -r tz_name tz_display <<< "$tz_info"
        
        # Get current time for this timezone
        CURRENT_TIME=$(TZ="$tz_name" date '+%H:%M')
        
        COLOR=$GREY
        if [ "$tz_name" = "$SELECTED_TZ" ]; then
            COLOR=$WHITE
        fi
        
        # Picking the system timezone removes the file (clock.sh then shows the clock icon)
        if [ "$tz_name" = "$CURRENT_TZ" ]; then
            SAVE_TZ="rm -f '$TZ_FILE'"
        else
            SAVE_TZ="mkdir -p '${TZ_FILE%/*}' && echo '$tz_name' > '$TZ_FILE'"
        fi

        args+=(--add item timezone.item.$COUNTER popup."$NAME"
            --set timezone.item.$COUNTER label="$tz_display - $CURRENT_TIME"
            label.color="$COLOR"
            background.color="$PURE_BLACK"
            background.drawing=on
            background.corner_radius=5
            padding_left=8
            padding_right=8
            padding_top=4
            padding_bottom=4
            margin=2
            click_script="$SAVE_TZ; sketchybar --set /timezone.item\.*/ label.color=$GREY --set timezone.item.$COUNTER label.color=$WHITE --set $NAME popup.drawing=off --trigger timezone_changed")
        COUNTER=$((COUNTER + 1))
    done
    
    sketchybar -m "${args[@]}" >/dev/null
}

toggle_timezones
