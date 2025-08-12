#!/bin/bash
NET_BASE=1024

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
  
  # Unit arrays (starting from kB/kb, no B/b)
  local units_bytes=("kB" "MB" "GB" "TB")

  # Choose unit set
  local -a units
  units=(${units_bytes[@]})

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
  
  printf "%03d%s\n" "$value" "${units[$idx]}"
}

# Test cases
echo "Testing various speeds:"
echo "0 B/s -> $(format_speed 0)"
echo "512 B/s -> $(format_speed 512)"
echo "1024 B/s (1kB) -> $(format_speed 1024)"
echo "1000 kB/s -> $(format_speed $((1000*1024)))"
echo "1023 kB/s -> $(format_speed $((1023*1024)))"
echo "1024 kB/s (1MB) -> $(format_speed $((1024*1024)))"
echo "1500 kB/s -> $(format_speed $((1500*1024)))"
echo "10 MB/s -> $(format_speed $((10*1024*1024)))"
