#!/bin/bash

# Efficient network throughput sampler using netstat -ib (built-in on macOS).
# - Persists byte counters to compute deltas across runs
# - Caches computed speeds briefly so `net_up` and `net_down` items don't double work

STATE_FILE="$TMPDIR/sketchybar_net_bytes"
RESULTS_FILE="$TMPDIR/sketchybar_net_speed"

# Config (can be overridden via env when launching sketchybar)
# - NET_USE_BITS=1 to show bits (b/kb/mb/gb) instead of bytes (B/kB/MB/GB)
# - NET_BASE=1000 for decimal (k=1000), NET_BASE=1024 for binary (KiB, etc.)
: "${NET_USE_BITS:=0}"
: "${NET_BASE:=1024}"

get_primary_interface() {
  local def
  def=$(route get default 2>/dev/null | awk '/interface:/{print $2; exit}')
  if [[ -z "$def" ]]; then
    echo ""
    return
  fi
  # If default iface is a virtual/tunnel, prefer a physical interface
  if [[ "$def" =~ ^(utun|awdl|llw|lo)[0-9]*$ ]]; then
    # Pick first active en* interface
    local phys
    phys=$(ifconfig | awk '/^en[0-9]+:/{iface=$1; gsub(":","",iface)} /status: active/ && iface{print iface; iface=""; exit}')
    if [[ -n "$phys" ]]; then
      echo "$phys"
      return
    fi
  fi
  echo "$def"
}

read_counters() {
  local iface="$1"
  # More robust parsing: handle multiple Link rows and ensure we get the right one
  netstat -ibI "$iface" 2>/dev/null | awk '
    BEGIN { ib=0; ob=0; rx=0; tx=0; found=0 }
    NR==1 {
      for (i=1; i<=NF; i++) {
        f=tolower($i)
        if (f=="ibytes") ib=i
        else if (f=="obytes") ob=i
      }
    }
    NR>1 && $0 ~ /Link/ && !found {
      # Take the first Link row with valid byte counters
      if (ib>0 && ob>0 && NF>=ob && $(ib) ~ /^[0-9]+$/ && $(ob) ~ /^[0-9]+$/) {
        rx=$(ib); tx=$(ob); found=1
      }
    }
    END { 
      if (rx==""||rx=="-"||!rx) rx=0
      if (tx==""||tx=="-"||!tx) tx=0
      print rx " " tx
    }
  ' || echo "0 0"
}

format_speed() {
  local bytes_per_sec=$1
  local base=$NET_BASE

  # Handle zero or very low speeds
  if (( bytes_per_sec == 0 )); then
    printf "000kB"
    return
  fi

  # Start with kB as base unit (convert bytes to kilobytes)
  local value=$(( bytes_per_sec / base ))
  
  # If less than 1kB/s, show as 001kB minimum
  if (( value == 0 )); then
    value=1
  fi
  
  # Convert to bits if requested (after converting to kB)
  if (( NET_USE_BITS == 1 )); then
    value=$(( value * 8 ))
  fi

  # Unit arrays (starting from kB/kb, no B/b)
  local units_bytes=("kB" "MB" "GB" "TB")
  local units_bits=("kb" "mb" "gb" "tb")

  # Choose unit set
  local -a units
  if (( NET_USE_BITS == 1 )); then
    units=(${units_bits[@]})
  else
    units=(${units_bytes[@]})
  fi

  local idx=0
  local max_idx=$(( ${#units[@]} - 1 ))
  
  # Find the appropriate unit to keep value under 1000
  while (( idx < max_idx )); do
    # If value would be >= 1000 in display, try next unit
    if (( value >= 1000 )); then
      # Check if moving to next unit would give us at least 1
      local test_value=$(( value / base ))
      if (( test_value > 0 )); then
        # Safe to move to next unit
        value=$test_value
        ((idx++))
      else
        # Would result in 0, stay in current unit and clamp
        value=999
        break
      fi
    else
      break  # Value fits in 3 digits, we're good
    fi
  done
  
  # Final safety check
  if (( value > 999 )); then value=999; fi
  
  printf "%03d%s" "$value" "${units[$idx]}"
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
  read -r res_ts res_down res_up < "$RESULTS_FILE" 2>/dev/null || true
  if [[ -n "$res_ts" ]] && (( timestamp_now - res_ts < 1 )); then
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
  read -r last_ts last_rx last_tx < "$STATE_FILE" 2>/dev/null || true
  # Validate the read values
  if [[ -z "$last_ts" || -z "$last_rx" || -z "$last_tx" ]]; then
    last_ts=$timestamp_now
    last_rx=$rx_now
    last_tx=$tx_now
  fi
else
  last_ts=$timestamp_now
  last_rx=$rx_now
  last_tx=$tx_now
fi

elapsed=$(( timestamp_now - last_ts ))
if (( elapsed <= 0 )); then elapsed=1; fi

# Handle counter overflow or reset
if (( rx_now < last_rx )); then
  # Counter reset/overflow, use current value as delta
  drx=$rx_now
else
  drx=$(( rx_now - last_rx ))
fi

if (( tx_now < last_tx )); then
  # Counter reset/overflow, use current value as delta
  dtx=$tx_now
else
  dtx=$(( tx_now - last_tx ))
fi

# Sanity check: cap at reasonable speed (10 GB/s)
max_bytes=$(( 10 * 1024 * 1024 * 1024 * elapsed ))
if (( drx > max_bytes )); then drx=0; fi
if (( dtx > max_bytes )); then dtx=0; fi

# Round to nearest instead of truncating
down_bps=$(( (drx + elapsed/2) / elapsed ))
up_bps=$(( (dtx + elapsed/2) / elapsed ))

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


