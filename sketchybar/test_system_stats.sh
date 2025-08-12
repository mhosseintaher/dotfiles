#!/bin/bash

echo "=== Testing System Stats ==="
echo ""

# Test CPU
echo "CPU Usage Test:"
echo "From our script: $(bash .config/sketchybar/plugins/cpu.sh 2>&1 | grep -o '[0-9]*%' || echo 'Error')"
echo "From Activity Monitor (top): $(top -l 1 | grep "CPU usage" | awk '{print $3 " user, " $5 " sys"}')"
echo ""

# Test Memory
echo "Memory Usage Test:"
echo "From our script: $(bash .config/sketchybar/plugins/memory.sh 2>&1 | grep -o '[0-9]*%' || echo 'Error')"

# Calculate memory using vm_stat for comparison
vm_out=$(vm_stat)
page_size=$(sysctl -n hw.pagesize)
pages_wired=$(echo "$vm_out" | awk '/Pages wired down:/ {gsub(/\./,""); print $4}')
pages_compressed=$(echo "$vm_out" | awk '/Pages occupied by compressor:/ {gsub(/\./,""); print $5}')
pages_active=$(echo "$vm_out" | awk '/Pages active:/ {gsub(/\./,""); print $3}')
mem_bytes=$(sysctl -n hw.memsize)

: ${pages_wired:=0}
: ${pages_compressed:=0}
: ${pages_active:=0}

used_bytes=$(( (pages_wired + pages_compressed + pages_active/2) * page_size ))
percent=$(( (used_bytes * 100) / mem_bytes ))

echo "Calculated directly: ${percent}%"
echo ""

echo "Raw vm_stat output (first few lines):"
vm_stat | head -20
