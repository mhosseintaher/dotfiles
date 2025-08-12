#!/bin/bash

# Energy-friendly CPU usage sampling. Avoids heavy `top` parsing.
# Uses `ps` once per run and minimal awk. We also reduce frequency via item config.

get_cpu_usage_percent() {
  # More accurate CPU usage using top -l 2 (2 samples for accuracy)
  # The first sample may be inaccurate, so we use the second one
  local cpu_info
  cpu_info=$(top -l 2 -n 0 -F -R -s 1 | grep "CPU usage" | tail -1)
  
  if [[ -n "$cpu_info" ]]; then
    # Extract user and sys percentages
    local user_cpu sys_cpu
    user_cpu=$(echo "$cpu_info" | awk '{gsub(/%/,""); print $3}')
    sys_cpu=$(echo "$cpu_info" | awk '{gsub(/%/,""); print $5}')
    
    # Handle missing values
    if [[ -z "$user_cpu" ]]; then user_cpu=0; fi
    if [[ -z "$sys_cpu" ]]; then sys_cpu=0; fi
    
    # Total CPU = user + sys (idle is not included)
    # Convert to integers for arithmetic (bash doesn't handle floats)
    local user_int=${user_cpu%%.*}
    local sys_int=${sys_cpu%%.*}
    local total_cpu=$(( user_int + sys_int ))
    
    # Ensure valid range
    if [[ "$total_cpu" -lt 0 ]]; then total_cpu=0; fi
    if [[ "$total_cpu" -gt 100 ]]; then total_cpu=100; fi
    
    echo "$total_cpu"
  else
    echo 0
  fi
}

PERCENT=$(get_cpu_usage_percent)

sketchybar --set "$NAME" label="$(printf "%02d" "$PERCENT")%"


