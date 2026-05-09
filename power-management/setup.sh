#!/bin/bash
#
# macOS Power Management Setup
# -----------------------------
# Applies pmset sleep/hibernate settings for both battery and AC power.
# Run this on a fresh Mac to restore your preferred power behaviour.
#
# Requires sudo.
#

set -e

echo "⚡ Applying power management settings..."

# --- Battery ---
# display sleeps after 10 min idle
# system sleeps 1 min after display sleep (~11 min total)
# hibernatemode 25: RAM written to disk, power fully cut (aggressive battery saving)
# powernap off: no background activity during sleep
# ttyskeepawake off: terminal sessions don't prevent sleep on battery
sudo pmset -b \
    displaysleep 10 \
    sleep 1 \
    hibernatemode 25 \
    powernap 0 \
    ttyskeepawake 0 \
    womp 0 \
    standby 1

echo "  ✅ Battery settings applied"

# --- AC (plugged in) ---
# display sleeps after 30 min idle
# system sleeps 60 min after display sleep (90 min total from last activity)
# hibernatemode 3: standard sleep, RAM stays powered (fast wake)
# powernap on: allows background activity (mail, backups, etc.) during sleep
# ttyskeepawake on: active terminal sessions keep system awake
sudo pmset -c \
    displaysleep 30 \
    sleep 60 \
    hibernatemode 3 \
    powernap 1 \
    ttyskeepawake 1 \
    womp 0 \
    standby 1

echo "  ✅ AC settings applied"

echo ""
echo "Done. Verify with: pmset -g custom"
