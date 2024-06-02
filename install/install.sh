#!/bin/bash

# Path to dotfiles
DOT="$HOME/dotfiles"

# Remove files from home folder
rm $HOME/.gitconfig
rm $HOME/.zshrc

# Create symlinks
ln -sv $DOT/.zshrc $HOME/
ln -sv $DOT/.gitconfig $HOME/

# If Input Remapper preset folder for laptop exists, run a script to create the appropriate symlink
if [ -d "$HOME/.config/input-remapper-2/presets/AT Translated Set 2 keyboard" ]; then
  $DOT/remapper/create-symlink-laptop.sh
else
  echo "Input Remapper preset folder for laptop does not exist."
fi

echo "Installation complete. Restart shell."
