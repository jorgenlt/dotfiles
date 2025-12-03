#!/bin/bash

SOURCE_FILE="$DOT/config/remapper/jlt-colemak-custom.json"
SYMLINK_PATH="$HOME/.config/input-remapper-2/presets/AT Translated Set 2 keyboard/jlt-colemak-custom.json"

print_header() {
  echo -e "\n\e[1;32m$1\e[0m"
}

# Check if the symlink already exists
if [ -L "$SYMLINK_PATH" ]; then
  print_header "Input Remapper laptop preset symlink ✅"
else
  # Create the symlink
  ln -s "$SOURCE_FILE" "$SYMLINK_PATH"
  print_header "Symlink created for Input Remapper laptop preset ✅"
fi
