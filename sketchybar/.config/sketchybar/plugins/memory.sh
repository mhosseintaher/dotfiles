#!/bin/bash

# Energy-friendly memory sampling. Parses `vm_stat` minimally.
# Uses page counts to compute used percent: active + wired + compressed.

get_memory_percent() {
  # page size in bytes
  local page_size
  page_size=$(sysctl -n hw.pagesize 2>/dev/null)
  if [[ -z "$page_size" || "$page_size" -le 0 ]]; then page_size=4096; fi

  # vm_stat values are in pages
  local vm_out
  vm_out=$(vm_stat)

  # Extract relevant page counts - parse more carefully
  local pages_active pages_wired pages_compressed pages_app
  pages_active=$(echo "$vm_out" | awk '/Pages active:/ {gsub(/\./,""); print $3}')
  pages_wired=$(echo "$vm_out" | awk '/Pages wired down:/ {gsub(/\./,""); print $4}')
  pages_compressed=$(echo "$vm_out" | awk '/Pages occupied by compressor:/ {gsub(/\./,""); print $5}')
  
  # Also get app memory (anonymous pages) for more accurate calculation
  pages_app=$(echo "$vm_out" | awk '/Anonymous pages:/ {gsub(/\./,""); print $3}')
  
  # Handle missing values
  : ${pages_active:=0}
  : ${pages_wired:=0}
  : ${pages_compressed:=0}
  : ${pages_app:=0}

  # total memory
  local mem_bytes
  mem_bytes=$(sysctl -n hw.memsize)

  # Calculate used memory more accurately
  # Memory pressure = wired + compressed + (portion of active that's not reclaimable)
  # This better matches Activity Monitor's "Memory Used"
  local used_pages=$(( pages_wired + pages_compressed ))
  
  # Add non-purgeable active pages (approximation)
  if [[ "$pages_active" -gt 0 ]]; then
    # Only count ~70% of active pages as truly used (rest is cache)
    used_pages=$(( used_pages + (pages_active * 7 / 10) ))
  fi
  
  local used_bytes=$(( used_pages * page_size ))

  if [[ "$mem_bytes" -gt 0 ]]; then
    # More precise calculation with rounding
    local percent=$(( (used_bytes * 100 + mem_bytes/2) / mem_bytes ))
    # Ensure valid range
    if [[ "$percent" -lt 0 ]]; then percent=0; fi
    if [[ "$percent" -gt 100 ]]; then percent=100; fi
    echo "$percent"
  else
    echo 0
  fi
}

PERCENT=$(get_memory_percent)

sketchybar --set "$NAME" label="$(printf "%02d" "$PERCENT")%"


