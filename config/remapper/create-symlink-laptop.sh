#!/bin/bash

SOURCE_FILE="$DOT/config/remapper/jlt-colemak-custom.json"
SYMLINK_PATH="$HOME/.config/input-remapper-2/presets/AT Translated Set 2 keyboard/jlt-colemak-custom.json"

# Check if the symlink already exists
if [ -L "$SYMLINK_PATH" ]; then
  echo "Input Remapper laptop preset symlink ✅"
else
  # Create the symlink
  ln -s "$SOURCE_FILE" "$SYMLINK_PATH"
  echo "Symlink created for Input Remapper laptop preset ✅"
fi
