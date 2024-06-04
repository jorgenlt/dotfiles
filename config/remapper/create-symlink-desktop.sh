#!/bin/bash

SOURCE_FILE="$DOT/config/remapper/jlt-colemak-custom-desktop.json"
SYMLINK_PATH="$HOME/.config/input-remapper-2/presets/Ducky Ducky One2 Mini/jlt-colemak-custom-desktop.json"

# Check if the symlink already exists
if [ -L "$SYMLINK_PATH" ]; then
  echo "Input Remapper desktop preset symlink ✅"
else
  # Create the symlink
  ln -s "$SOURCE_FILE" "$SYMLINK_PATH"
  echo "Symlink created for Input Remapper desktop preset ✅"
fi
