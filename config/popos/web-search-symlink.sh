#!/bin/bash

file_name="config.ron"
target="/usr/lib/pop-launcher/plugins/web/$file_name"
source="$DOT/config/popos/$file_name"

if [ -L "$target" ]; then
  echo "$file_name symlink ✅"
else
  echo "Symlink for $target does not exist."

  if sudo rm -f "$target"; then
    echo "Removed existing file: $target."
  fi

  echo "Creating a symlink for $file_name"

  if sudo ln -s "$source" "$target"; then
    echo "Symlink created for $file_name: $target."
  fi
fi

echo