#!/usr/bin/env bash

# Usage: ./daysuntil_weeks.sh YYYY-MM-DD
# Prints:
# - "X weeks and Y days left until TARGET"  if TARGET is in the future
# - "Today is TARGET!"                   if TARGET is today
# - "X weeks and Y days ago was TARGET"   if TARGET is in the past

# Determine a robust epoch for midnight of a given date (works with GNU date and BSD date)
to_epoch_midnight() {
  local d="$1"
  if date -d "$d" +%s >/dev/null 2>&1; then
    date -d "$d" +%s
  else
    # macOS / BSD date
    date -j -f "%Y-%m-%d" "$d" "+%s"
  fi
}

if [[ -z "$1" ]]; then
  echo "Usage: $0 YYYY-MM-DD"
  exit 1
fi

target="$1"

# Midnight epoch for today and for the target date
today="$(date +%F)"            # YYYY-MM-DD
today_midnight=$(to_epoch_midnight "$today")
target_midnight=$(to_epoch_midnight "$target")

diff_sec=$(( target_midnight - today_midnight ))
days=$(( diff_sec / 86400 ))      # full days difference

# Helper for simple pluralization
plural() { local n="$1"; if (( n == 1 )); then echo ""; else echo "s"; fi; }

# Normalize for weeks/days calculation
if (( days > 0 )); then
  days_abs=$days
elif (( days < 0 )); then
  days_abs=$(( -days ))
else
  days_abs=0
fi

weeks=$(( days_abs / 7 ))
rem_days=$(( days_abs % 7 ))

if (( days > 0 )); then
  printf "%d week%s and %d day%s left until %s\n" "$weeks" "$(plural "$weeks")" "$rem_days" "$(plural "$rem_days")" "$target"
elif (( days == 0 )); then
  echo "Today is $target!"
else
  printf "%d week%s and %d day%s ago was %s\n" "$weeks" "$(plural "$weeks")" "$rem_days" "$(plural "$rem_days")" "$target"
fi
