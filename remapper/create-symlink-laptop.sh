#!/bin/bash

SOURCE_FILE="$DOT/remapper/jlt-colemak-custom.json"
SYMLINK_PATH="$HOME/.config/input-remapper-2/presets/AT Translated Set 2 keyboard/jlt-colemak-custom.json"

# Check if the symlink already exists
if [ ! -L "$SYMLINK_PATH" ]; then
  # Create the symlink
  ln -sv "$SOURCE_FILE" "$SYMLINK_PATH"
else
  echo "Symlink already exists."
fi
