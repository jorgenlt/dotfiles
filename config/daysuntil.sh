#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 YYYY-MM-DD"
  exit 1
fi

target="$1"
days=$(( ($(date -d "$target" +%s) - $(date +%s)) / 86400 ))

if [ "$days" -gt 0 ]; then
  echo "$days days left until $target"
elif [ "$days" -eq 0 ]; then
  echo "Today is $target!"
else
  echo "$((-days)) days ago was $target"
fi

# Usage: ./daysuntil.sh 2026-12-25
