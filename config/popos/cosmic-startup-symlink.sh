#!/bin/bash

file_name="cosmic-startup.desktop"
target="$HOME/.config/autostart/$file_name"
source="$DOT/config/popos/$file_name"

print_header() {
  echo -e "\n\e[1;32m$1\e[0m"
}

# Ensure the target directory exists
mkdir -p "$(dirname "$target")"

if [ -L "$target" ]; then
  print_header "$file_name symlink ✅"
else
  print_header "Symlink for $target does not exist."

  if rm -f "$target"; then
    echo "Removed existing file: $target."
  fi

  echo "Creating a symlink for $file_name"

  if ln -s "$source" "$target"; then
    echo "Symlink created for $file_name: $target."
  fi
fi

echo
