#!/bin/sh

source "$CONFIG_DIR/colors.sh"

# One pmset call; percentage = the digits right before the first "%".
BATT="$(pmset -g batt)"
PERCENTAGE=""
case "$BATT" in
  *%*) PERCENTAGE="${BATT%%\%*}"; PERCENTAGE="${PERCENTAGE##*[!0-9]}" ;;
esac
CHARGING=""
case "$BATT" in
  *"AC Power"*) CHARGING=1 ;;
esac

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case ${PERCENTAGE} in
  [8-9][0-9] | 100)
    ICON=""
    ICON_COLOR=$BATTERY_1
    ;;
  7[0-9])
    ICON=""
    ICON_COLOR=$BATTERY_2
    ;;
  [4-6][0-9])
    ICON=""
    ICON_COLOR=$BATTERY_3
    ;;
  [1-3][0-9])
      ICON=""
    ICON_COLOR=$BATTERY_4
    ;;
  [0-9])
    ICON=""
    ICON_COLOR=$BATTERY_5
    ;;
esac

if [ -n "$CHARGING" ]; then
  ICON=""
  ICON_COLOR=$YELLOW
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color=${ICON_COLOR}
