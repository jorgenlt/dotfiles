#!/usr/bin/env bash
# Spread all windows on the *current* (focused) workspace
# onto separate workspaces (one window per workspace).
# Requires: cosmic-ext-window-helper + jq

set -euo pipefail

if ! command -v cosmic-ext-window-helper >/dev/null; then
  echo "Install cosmic-ext-window-helper first (pipx install cosmic-ext-window-helper)" >&2
  exit 1
fi
if ! command -v jq >/dev/null; then
  echo "jq is required" >&2
  exit 1
fi

# Get full state
STATE=$(cosmic-ext-window-helper state)

# Windows that are on a focused workspace (i.e. current workspace)
# Prefer keeping the currently active window on the current workspace.
mapfile -t WINDOWS < <(echo "$STATE" | jq -r '
  [.[] | select(.workspace.has_focus == true)]
  | sort_by(.is_active | not)   # active window first
  | .[]
  | "\(.id)\t\(.workspace.name)\t\(.output.name)"
')

if (( ${#WINDOWS[@]} <= 1 )); then
  echo "0 or 1 window on current workspace — nothing to do."
  exit 0
fi

# First window stays where it is
read -r KEEP_ID CURRENT_WS CURRENT_OUTPUT <<< "${WINDOWS[0]}"
echo "Keeping window $KEEP_ID on workspace $CURRENT_WS ($CURRENT_OUTPUT)"

# Remaining windows → consecutive higher workspaces
TARGET=$((CURRENT_WS + 1))

for ((i=1; i<${#WINDOWS[@]}; i++)); do
  read -r ID WS OUT <<< "${WINDOWS[$i]}"
  echo "Moving window $ID → workspace $TARGET on $OUT"
  cosmic-ext-window-helper move_to "id='$ID'" "$TARGET" "$OUT"
  ((TARGET++))
done

echo "Done. Windows spread across workspaces $CURRENT_WS … $((TARGET-1))"
