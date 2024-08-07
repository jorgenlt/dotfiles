#!/bin/bash

SOURCE_FILE_KEYBOARD="$DOT/config/remapper/jlt-colemak-custom-desktop.json"
SYMLINK_PATH_KEYBOARD="$HOME/.config/input-remapper-2/presets/Ducky Ducky One2 Mini/jlt-colemak-custom-desktop.json"

# Check if the symlink already exists
if [ -L "$SYMLINK_PATH_KEYBOARD" ]; then
  echo "Input Remapper desktop keyboard preset symlink ✅"
else
  # Create the symlink
  ln -s "$SOURCE_FILE_KEYBOARD" "$SYMLINK_PATH_KEYBOARD"
  echo "Symlink created for Input Remapper desktop keyboard preset ✅"
fi

SOURCE_FILE_MOUSE="$DOT/config/remapper/mouse-remapper-desktop.json"
SYMLINK_PATH_MOUSE="$HOME/.config/input-remapper-2/presets/Logitech MX518 Gaming Mouse/mouse-remapper-desktop.json"

# Check if the symlink already exists
if [ -L "$SYMLINK_PATH_MOUSE" ]; then
  echo "Input Remapper desktop mouse preset symlink ✅"
else
  # Create the symlink
  ln -s "$SOURCE_FILE_MOUSE" "$SYMLINK_PATH_MOUSE"
  echo "Symlink created for Input Remapper desktop mouse preset ✅"
fi
