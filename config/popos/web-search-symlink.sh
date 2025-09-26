#!/bin/bash

file_name="config.ron"
target="/usr/lib/pop-launcher/plugins/web/$file_name"
source="$DOT/config/popos/$file_name"

print_header() {
  echo -e "\n\e[1;32m$1\e[0m"
}

if [ -L "$target" ]; then
  print_header "$file_name symlink ✅"
else
  print_header "Symlink for $target does not exist."

  if sudo rm -f "$target"; then
    echo "Removed existing file: $target."
  fi

  echo "Creating a symlink for $file_name"

  if sudo ln -s "$source" "$target"; then
    echo "Symlink created for $file_name: $target."
  fi
fi

echo