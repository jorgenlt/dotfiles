#!/usr/bin/env bash
# Spread all windows on the *current* workspace
# onto separate workspaces (one window per workspace).
# Pop!_OS 22.04 + GNOME / Pop Shell (X11)
# Requires: wmctrl + xdotool

set -euo pipefail

if ! command -v wmctrl >/dev/null || ! command -v xdotool >/dev/null; then
  echo "Install: sudo apt install wmctrl xdotool" >&2
  exit 1
fi

# Current workspace (0-based)
CURRENT=$(wmctrl -d | awk '/\*/ {print $1}')
echo "Current workspace: $CURRENT"

# Windows currently on this workspace
mapfile -t WINDOWS < <(wmctrl -l | awk -v ws="$CURRENT" '$2 == ws {print $1}')

COUNT=${#WINDOWS[@]}
if (( COUNT <= 1 )); then
  echo "0 or 1 window on current workspace — nothing to do."
  exit 0
fi

# Prefer keeping the active window
ACTIVE=$(xdotool getactivewindow 2>/dev/null || true)
KEEP=""

if [[ -n "$ACTIVE" ]]; then
  ACTIVE_HEX=$(printf "0x%08x" "$ACTIVE")
  for id in "${WINDOWS[@]}"; do
    if [[ "${id,,}" == "${ACTIVE_HEX,,}" ]]; then
      KEEP="$id"
      break
    fi
  done
fi
[[ -z "$KEEP" ]] && KEEP="${WINDOWS[0]}"

echo "Keeping window $KEEP on workspace $CURRENT"

# -------------------------------------------------
# Force enough workspaces to exist
# (this is the part that was missing)
# -------------------------------------------------
NEEDED=$((CURRENT + COUNT + 2))   # a couple of extras for safety
CURRENT_NUM=$(wmctrl -d | wc -l)

if (( CURRENT_NUM < NEEDED )); then
  echo "Creating more workspaces (need $NEEDED, currently $CURRENT_NUM)..."
  # Temporarily switch to fixed workspaces so wmctrl -n is respected
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.desktop.wm.preferences num-workspaces "$NEEDED"
  sleep 0.3
fi

# Move the extra windows
TARGET=$((CURRENT + 1))
for id in "${WINDOWS[@]}"; do
  if [[ "$id" == "$KEEP" ]]; then
    continue
  fi
  echo "Moving $id → workspace $TARGET"
  wmctrl -i -r "$id" -t "$TARGET"
  ((TARGET++))
done

gsettings set org.gnome.mutter dynamic-workspaces true

