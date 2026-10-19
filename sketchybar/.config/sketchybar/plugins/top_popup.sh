#!/bin/bash

# Click popup for the cpu and memory items: the top 10 processes, sorted by
# CPU (cpu item) or by resident memory (memory item). It runs only on click,
# with a single `ps` call, and fills the rows made by items/top_rows.sh in
# one sketchybar call. Click again or move the mouse away to close it.

case "$SENDER" in
  mouse.exited.global)
    sketchybar --set "$NAME" popup.drawing=off
    exit 0
    ;;
  mouse.clicked) ;;
  *) exit 0 ;;
esac

SORT=-r
[ "$NAME" = "memory" ] && SORT=-m

# Row: name, %CPU (per core, so it can pass 100), RSS in K/M/G.
ROWS=$(LC_ALL=C ps -Aco pid,pcpu,rss,comm "$SORT" | LC_ALL=C awk '
  NR > 1 && NR <= 11 {
    name = $0
    sub(/^ *[0-9]+ +[0-9.]+ +[0-9]+ +/, "", name)
    rss = $3
    if (rss >= 1048576)   mem = sprintf("%.1fG", rss / 1048576)
    else if (rss >= 1024) mem = sprintf("%.0fM", rss / 1024)
    else                  mem = rss "K"
    printf "%-24.24s %5.1f%% %6s\n", name, $2, mem
  }')

args=()
i=0
while IFS= read -r row; do
  args+=(--set "$NAME.top.$i" label="$row")
  i=$((i + 1))
done <<< "$ROWS"

# Close the sibling stats popups so they never overlap this one.
for other in cpu memory net_down net_up; do
  [ "$other" = "$NAME" ] || args+=(--set "$other" popup.drawing=off)
done

sketchybar "${args[@]}" --set "$NAME" popup.drawing=toggle
