#!/bin/bash

# Labels are pushed by helpers/sb_stats (started in sketchybarrc), so these
# items have no polling script. The script only drives the click popup.
net_down_item=(
  script="$PLUGIN_DIR/net_popup.sh"
  icon=$NET_DOWN
  label="000kB"
  icon.drawing=on
  label.drawing=on
  background.color="$PURE_BLACK"
  icon.align=center
  icon.padding_left=3
  icon.padding_right=3
  padding_left=5
  padding_right=0
  background.drawing=off
  update_freq=0
  updates=when_shown
)

net_up_item=(
  script="$PLUGIN_DIR/net_popup.sh"
  icon=$NET_UP
  label="000kB"
  icon.drawing=on
  label.drawing=on
  background.color="$PURE_BLACK"
  icon.align=center
  icon.padding_left=3
  icon.padding_right=3
  padding_left=10
  padding_right=0
  background.drawing=off
  update_freq=0
  updates=when_shown
)

net_popup=(
  popup.align=right
  popup.background.color="$PURE_BLACK"
  popup.background.corner_radius=6
  popup.background.border_color="$BACKGROUND_2"
  popup.background.border_width=1
)

sketchybar --add item net_down right \
           --set net_down "${net_down_item[@]}" "${net_popup[@]}" \
           --subscribe net_down mouse.clicked mouse.exited.global \
           --add item net_up right \
           --set net_up "${net_up_item[@]}" "${net_popup[@]}" \
           --subscribe net_up mouse.clicked mouse.exited.global

# Popup rows (filled on click by plugins/net_popup.sh): interface, local IP,
# gateway, VPN, then two action rows.
net_row=(
  icon.drawing=off
  background.drawing=off
  label.font="$FONT:Regular:13.0"
  label.color=$WHITE
  label.padding_left=10
  label.padding_right=10
  padding_left=0
  padding_right=0
)
net_args=()
for item in net_down net_up; do
  for i in 0 1 2 3; do
    net_args+=(--add item "$item.net.$i" "popup.$item"
               --set "$item.net.$i" "${net_row[@]}")
  done
  net_args+=(--add item "$item.net.settings" "popup.$item"
             --set "$item.net.settings" "${net_row[@]}" label.color=$BLUE
                   label="Network Settings…"
                   click_script="sketchybar --set $item popup.drawing=off; open 'x-apple.systempreferences:com.apple.Network-Settings.extension'"
             --add item "$item.net.monitor" "popup.$item"
             --set "$item.net.monitor" "${net_row[@]}" label.color=$BLUE
                   label="Activity Monitor…"
                   click_script="sketchybar --set $item popup.drawing=off; open -a 'Activity Monitor'")
done
sketchybar "${net_args[@]}"
