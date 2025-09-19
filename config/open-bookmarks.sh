#!/bin/bash

set -euo pipefail

FOLDER="${1:-}"
BOOKMARKS="${2:-"$HOME/.config/vivaldi/Default/Bookmarks"}"

if [ -z "$FOLDER" ]; then
  echo "Usage: $0 \"Bookmark Folder Name\" [path/to/Bookmarks]"
  exit 2
fi

command -v jq >/dev/null 2>&1 || { echo "jq is required. Install it and retry."; exit 3; }
command -v vivaldi >/dev/null 2>&1 || { echo "vivaldi binary not found in PATH."; exit 4; }
[ -f "$BOOKMARKS" ] || { echo "Bookmarks file not found: $BOOKMARKS"; exit 5; }

# extract URLs from all folders named $FOLDER (recursive) with jq
mapfile -t URLS < <(
  jq -r --arg name "$FOLDER" '
    def urls:
      if (.type? == "url") then [ .url ]
      else (.children? // [] | map(urls) | add // [])
      end;
    [ .. | objects | select(.type?=="folder" and .name==$name) | urls ] | add // [] | .[]
  ' "$BOOKMARKS"
)

if [ ${#URLS[@]} -eq 0 ]; then
  echo "No bookmarks found in folder \"$FOLDER\" (searched: $BOOKMARKS)."
  exit 6
fi

echo "🚀 Opening ${#URLS[@]} bookmarks from \"$FOLDER\"..."
vivaldi --new-window "${URLS[@]}"

sleep 2

wait
kill -9 $PPID
