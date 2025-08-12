#!/bin/bash

#!/bin/bash

# Energy-friendly CPU usage sampling. Avoids heavy `top` parsing.
# Uses `ps` once per run and minimal awk. We also reduce frequency via item config.

get_cpu_usage_percent() {
  # ps -A -o %cpu outputs percentages per process; sum them and clamp at 100*cores which we normalize to 100%
  # Use `sar` or `iostat` if available, but keep dependencies minimal.
  local total
  total=$(ps -A -o %cpu | awk 'NR>1 { s+=$1 } END { printf("%.0f", s) }')
  # Normalize roughly: On macOS, %cpu can exceed 100 with multi-core. We cap at 800 for typical 8 cores, then map to 0-100.
  # Detect logical cores to scale better.
  local cores
  cores=$(sysctl -n hw.ncpu 2>/dev/null)
  if [[ -z "$cores" || "$cores" -le 0 ]]; then cores=8; fi
  local max=$((cores * 100))
  if [[ "$total" -gt "$max" ]]; then total=$max; fi
  # Scale to 0-100 by dividing by cores.
  local percent=$(( total / cores ))
  echo "$percent"
}

PERCENT=$(get_cpu_usage_percent)

sketchybar --set "$NAME" label="${PERCENT}%"


