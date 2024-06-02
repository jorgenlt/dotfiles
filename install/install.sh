#!/bin/bash

# Path to dotfiles
DOT="$HOME/dotfiles"

# Check if Github CLI is installed
if command -v gh &>/dev/null; then
  echo "Github CLI found ✅"
else
  echo "Github CLI is not installed."
  echo "https://github.com/cli/cli/tree/trunk"
  echo "Installation cancelled."
  exit
fi

# Check if Git is installed
if command -v git &>/dev/null; then
  echo "Git found ✅"
else
  echo "Git is not installed."
  echo "https://git-scm.com/download/linux"
  echo "Installation cancelled."
  exit
fi

# Check if Zsh is installed
if command -v zsh &>/dev/null; then
  echo "Zsh found ✅"
else
  echo "Zsh is not installed."
  echo "Starting installation..."
  sudo apt update
  sudo apt install zsh -y
  echo "Restart system."
fi

# Check if Oh My Zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh found ✅"
else
  echo "Oh My Zsh is not installed."
  echo "https://github.com/ohmyzsh/ohmyzsh"
  echo "Installation cancelled."
  exit
fi

# Check if Input Remapper is installed
if [ -d "$HOME/.config/input-remapper-2" ]; then
  echo "Input Remapper found ✅"
else
  echo "Is Input Remapper installed? The folder $HOME/.config/input-remapper-2 cannot be found."
  echo "https://github.com/sezanzeb/input-remapper"
  echo "Install and open application to create config folders."
  echo "Installation cancelled."
  exit
fi

# If Input Remapper preset folder for laptop exists, run a script to create the appropriate symlink
if [ -d "$HOME/.config/input-remapper-2/presets/AT Translated Set 2 keyboard" ]; then
  $DOT/remapper/create-symlink-laptop.sh
else
  echo "Input Remapper preset folder for laptop does not exist."
fi

# Check if VS Code is installed
if command -v code &>/dev/null; then
  echo "VS Code found ✅"
else
  echo "VS Code is not installed."
  echo "https://code.visualstudio.com"
  echo "Installation cancelled."
  exit
fi

# Check if Vivaldi is installed
if command -v vivaldi &>/dev/null; then
  echo "Vivaldi found ✅"
else
  echo "Vivaldi is not installed."
  echo "https://vivaldi.com/download/"
  echo "Installation cancelled."
  exit
fi

# Check if Chromium is installed
if command -v chromium &>/dev/null; then
  echo "Chromium found ✅"
else
  echo "Chromium is not installed."
  echo "Starting installation..."
  sudo apt update
  sudo apt install chromium-browser
fi

# Check if FiraCode Nerd Font Mono is installed
if fc-list | grep -iq 'firacode nerd font mono'; then
  echo "FiraCode Nerd Font Mono found ✅"
else
  echo "FiraCode Nerd Font is not installed."
  echo "https://www.nerdfonts.com/font-downloads"
  echo "Installation cancelled."
  exit
fi

# Check if Starship is installed
if command -v starship &>/dev/null; then
  echo "Starship found ✅"
else
  echo "Starship is not installed."
  echo "https://starship.rs"
  echo "Installation cancelled."
  exit
fi

# Remove files from home folder
rm -f $HOME/.gitconfig
rm -f $HOME/.zshrc

# Create symlinks
ln -sv $DOT/.zshrc $HOME/
ln -sv $DOT/.gitconfig $HOME/

echo "Installation complete. Restart shell."
