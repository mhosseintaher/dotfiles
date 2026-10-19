#!/bin/bash

# Click popup for net_down / net_up: physical interface, its local IP and
# gateway, and the VPN tunnel when the default route goes through one.
# Runs only on click (route, ifconfig, networksetup: about 30 ms), fills the
# rows made by items/network.sh in one sketchybar call.

case "$SENDER" in
  mouse.exited.global)
    sketchybar --set "$NAME" popup.drawing=off
    exit 0
    ;;
  mouse.clicked) ;;
  *) exit 0 ;;
esac

DEF_IF=""
GATEWAY=""
while read -r key val _; do
  case "$key" in
    interface:) DEF_IF=$val ;;
    gateway:) GATEWAY=$val ;;
  esac
done <<< "$(route -n get default 2>/dev/null)"

# One ifconfig pass: the first active en* interface with an IPv4 address,
# and the address of the default-route interface.
IFACE=""
IP=""
DEF_IP=""
cur=""
addr=""
active=0
flush() {
  [ "$cur" = "$DEF_IF" ] && DEF_IP=$addr
  case "$cur" in
    en*) if [ -z "$IFACE" ] && [ "$active" = 1 ] && [ -n "$addr" ]; then
           IFACE=$cur
           IP=$addr
         fi ;;
  esac
}
while IFS= read -r line; do
  case "$line" in
    [a-z]*:\ flags=*) flush; cur=${line%%:*}; addr=""; active=0 ;;
    *"inet "*) [ -z "$addr" ] && { set -- $line; addr=$2; } ;;
    *"status: active"*) active=1 ;;
  esac
done <<< "$(ifconfig)"
flush
case "$DEF_IF" in en*) IFACE=$DEF_IF; IP=$DEF_IP ;; esac

VPN="off"
if [ -n "$DEF_IF" ] && [ "$DEF_IF" != "$IFACE" ]; then
  VPN="$DEF_IF${DEF_IP:+ ($DEF_IP)}"
  # The default gateway belongs to the tunnel; show the physical one instead.
  GATEWAY=""
  [ -n "$IFACE" ] && while read -r key val _; do
    [ "$key" = "gateway:" ] && GATEWAY=$val
  done <<< "$(route -n get -ifscope "$IFACE" default 2>/dev/null)"
fi

PORT=""
[ -n "$IFACE" ] && PORT=$(networksetup -listallhardwareports 2>/dev/null |
  awk -v dev="Device: $IFACE" '/^Hardware Port: /{sub(/^Hardware Port: /, ""); p=$0} $0 == dev {print p; exit}')

printf -v L0 '%-10s %s' Interface "${IFACE:+${PORT:-Link} ($IFACE)}"
printf -v L1 '%-10s %s' "Local IP" "${IP:--}"
printf -v L2 '%-10s %s' Gateway "${GATEWAY:--}"
printf -v L3 '%-10s %s' VPN "$VPN"
[ -z "$IFACE" ] && printf -v L0 '%-10s %s' Interface "none"

# Close the sibling stats popups so they never overlap this one.
close=()
for other in cpu memory net_down net_up; do
  [ "$other" = "$NAME" ] || close+=(--set "$other" popup.drawing=off)
done

sketchybar "${close[@]}" \
           --set "$NAME.net.0" label="$L0" \
           --set "$NAME.net.1" label="$L1" \
           --set "$NAME.net.2" label="$L2" \
           --set "$NAME.net.3" label="$L3" \
           --set "$NAME" popup.drawing=toggle
