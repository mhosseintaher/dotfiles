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

  # Extract relevant page counts (use last field and strip non-digits to be robust across macOS versions/locales)
  local pages_active pages_wired pages_compressed
  pages_active=$(echo "$vm_out" | awk '/Pages active/ {gsub(/[^0-9]/, "", $NF); print $NF}')
  pages_wired=$(echo "$vm_out" | awk '/Pages wired/ {gsub(/[^0-9]/, "", $NF); print $NF}' | head -n1)
  pages_compressed=$(echo "$vm_out" | awk '/Pages occupied by compressor/ {gsub(/[^0-9]/, "", $NF); print $NF}')

  # total memory
  local mem_bytes
  mem_bytes=$(sysctl -n hw.memsize)

  # Calculate used: active + wired + compressed; speculative and inactive are considered reclaimable
  local used_bytes=$(( (pages_active + pages_wired + pages_compressed) * page_size ))

  if [[ "$mem_bytes" -gt 0 ]]; then
    local percent=$(( (used_bytes * 100) / mem_bytes ))
    echo "$percent"
  else
    echo 0
  fi
}

PERCENT=$(get_memory_percent)

sketchybar --set "$NAME" label="${PERCENT}%"


