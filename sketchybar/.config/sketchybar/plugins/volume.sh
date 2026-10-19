#!/bin/bash

WIDTH=100

volume_change() {
  source "$CONFIG_DIR/icons.sh"
  case $INFO in
    [6-9][0-9]|100) ICON=$VOLUME_100
    ;;
    [3-5][0-9]) ICON=$VOLUME_66
    ;;
    [1-2][0-9]) ICON=$VOLUME_33
    ;;
    [1-9]) ICON=$VOLUME_10
    ;;
    0) ICON=$VOLUME_0
    ;;
    *) ICON=$VOLUME_100
  esac

  # Only one collapse timer may live: a running one means the slider is
  # already open, so stop that timer and skip the open animation.
  TIMER_FILE="${TMPDIR:-/tmp}/sketchybar_volume_timer"
  OPEN=(--animate tanh 30 --set $NAME slider.width=$WIDTH)
  if [ -r "$TIMER_FILE" ] && read -r OLD < "$TIMER_FILE" \
     && [[ "$(ps -o command= -p "$OLD" 2>/dev/null)" == *volume.sh* ]]; then
    kill "$OLD" 2>/dev/null
    OPEN=()
  fi
  echo $$ > "$TIMER_FILE"

  sketchybar --set volume_icon label=$ICON \
             --set $NAME slider.percentage=$INFO \
             "${OPEN[@]}"

  sleep 2

  # Collapse unless a newer volume change took over the timer
  read -r CURRENT < "$TIMER_FILE"
  if [ "$CURRENT" = "$$" ]; then
    rm -f "$TIMER_FILE"
    sketchybar --animate tanh 30 --set $NAME slider.width=0
  fi
}

mouse_clicked() {
  osascript -e "set volume output volume $PERCENTAGE"
}

case "$SENDER" in
  "volume_change") volume_change
  ;;
  "mouse.clicked") mouse_clicked
  ;;
esac
