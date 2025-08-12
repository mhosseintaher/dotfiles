#!/bin/bash

# Efficient network throughput sampler using netstat -ib (built-in on macOS).
# - Persists byte counters to compute deltas across runs
# - Caches computed speeds briefly so `net_up` and `net_down` items don't double work

STATE_FILE="$TMPDIR/sketchybar_net_bytes"
RESULTS_FILE="$TMPDIR/sketchybar_net_speed"

get_primary_interface() {
  route get default 2>/dev/null | awk '/interface:/{print $2; exit}'
}

read_counters() {
  local iface="$1"
  # netstat -ib prints multiple lines per iface; choose line with Link# and non-zero Ibytes/Obytes
  netstat -ib | awk -v IF="$iface" '$1==IF && $0 ~ /Link/ { rx=$7; tx=$10; } END { print rx" "tx }'
}

format_speed() {
  local bytes_per_sec=$1
  if (( bytes_per_sec >= 1024*1024 )); then
    awk -v bps=$bytes_per_sec 'BEGIN{ printf("%.1fMB/s", bps/1024/1024) }'
  elif (( bytes_per_sec >= 1024 )); then
    awk -v bps=$bytes_per_sec 'BEGIN{ printf("%.1fKB/s", bps/1024) }'
  else
    printf "%dB/s" "$bytes_per_sec"
  fi
}

iface=$(get_primary_interface)
if [[ -z "$iface" ]]; then
  if [[ "$NAME" == "net_down" ]]; then
    sketchybar --set "$NAME" label="-"
  elif [[ "$NAME" == "net_up" ]]; then
    sketchybar --set "$NAME" label="-"
  else
    sketchybar --set "$NAME" label="-/-"
  fi
  exit 0
fi

timestamp_now=$(date +%s)

# If recent results exist (<1s), reuse to avoid duplicate heavy calls per tick
if [[ -f "$RESULTS_FILE" ]]; then
  read -r res_ts res_down res_up < "$RESULTS_FILE"
  if (( timestamp_now - res_ts < 1 )); then
    if [[ "$NAME" == "net_down" ]]; then
      sketchybar --set "$NAME" label="$res_down"
    elif [[ "$NAME" == "net_up" ]]; then
      sketchybar --set "$NAME" label="$res_up"
    else
      sketchybar --set "$NAME" label="${res_down} ↓  ${res_up} ↑"
    fi
    exit 0
  fi
fi

read -r rx_now tx_now < <(read_counters "$iface")

if [[ -f "$STATE_FILE" ]]; then
  read -r last_ts last_rx last_tx < "$STATE_FILE"
else
  last_ts=$timestamp_now
  last_rx=$rx_now
  last_tx=$tx_now
fi

elapsed=$(( timestamp_now - last_ts ))
if (( elapsed <= 0 )); then elapsed=1; fi

drx=$(( rx_now - last_rx ))
dtx=$(( tx_now - last_tx ))
if (( drx < 0 )); then drx=0; fi
if (( dtx < 0 )); then dtx=0; fi

down_bps=$(( drx / elapsed ))
up_bps=$(( dtx / elapsed ))

echo "$timestamp_now $rx_now $tx_now" > "$STATE_FILE"

down_str=$(format_speed "$down_bps")
up_str=$(format_speed "$up_bps")

echo "$timestamp_now" "$down_str" "$up_str" > "$RESULTS_FILE"

if [[ "$NAME" == "net_down" ]]; then
  sketchybar --set "$NAME" label="$down_str"
elif [[ "$NAME" == "net_up" ]]; then
  sketchybar --set "$NAME" label="$up_str"
else
  sketchybar --set "$NAME" label="${down_str} ↓  ${up_str} ↑"
fi


