#!/bin/bash

# Path to dotfiles
export DOT="$HOME/dotfiles"

# Function to check if a command is installed
check_command() {
  local command_name="$1"
  local display_name="$2"
  local install_url="$3"
  if command -v "$command_name" &>/dev/null; then
    echo "$display_name ✅"
  else
    echo "$display_name is not installed."
    echo "$install_url"
    echo "Installation cancelled."
    exit 1
  fi
  echo
}

# Function to check if a directory exists
check_directory() {
  local directory_path="$1"
  local display_name="$2"
  local install_url="$3"
  if [ -d "$directory_path" ]; then
    echo "$display_name ✅"
  else
    echo "$display_name is not installed."
    echo "$install_url"
    echo "Installation cancelled."
    exit 1
  fi
  echo
}

# Function to create a symlink in home folder
create_symlink_home() {
  local file_name="$1"
  local target="$HOME/$file_name"
  if [ -L "$target" ]; then
    echo "$file_name symlink ✅"
  else
    rm -f "$target"
    ln -s "$DOT/$file_name" "$target"
    echo "Symlink created for $file_name"
  fi
  echo
}

# Check required commands
check_command git "Git" "https://git-scm.com/download/linux"
check_command gh "Github CLI" "https://github.com/cli/cli/tree/trunk"
check_command code "VS Code" "https://code.visualstudio.com"
check_command vivaldi "Vivaldi" "https://vivaldi.com/download/"
check_command starship "Starship" "https://starship.rs"

# Check if Zsh is installed and install if not
if ! command -v zsh &>/dev/null; then
  echo "Zsh is not installed. Starting installation..."
  sudo apt update
  sudo apt install -y zsh
  echo "Restart system."
else
  echo "Zsh ✅"
fi
echo

# Check if Oh My Zsh is installed
check_directory "$HOME/.oh-my-zsh" "Oh My Zsh" "https://github.com/ohmyzsh/ohmyzsh"

# Check if Input Remapper is installed
check_directory "$HOME/.config/input-remapper-2" "Input Remapper" "https://github.com/sezanzeb/input-remapper"

# If Input Remapper preset folder for laptop exists, run a script to create the appropriate symlink
if [ -d "$HOME/.config/input-remapper-2/presets/AT Translated Set 2 keyboard" ]; then
  $DOT/config/remapper/create-symlink-laptop.sh
else
  echo "Input Remapper preset folder for laptop does not exist."
fi
echo

# Check if Chromium is installed and install if not
if ! command -v chromium &>/dev/null; then
  echo "Chromium is not installed. Starting installation..."
  sudo apt update
  sudo apt install -y chromium-browser
else
  echo "Chromium ✅"
fi
echo

# Check if FiraCode Nerd Font Mono is installed
if ! fc-list | grep -iq 'firacode nerd font mono'; then
  echo "FiraCode Nerd Font is not installed."
  echo "https://www.nerdfonts.com/font-downloads"
  echo "Installation cancelled."
  exit 1
else
  echo "FiraCode Nerd Font Mono ✅"
fi
echo

# Create symlinks in home folder
create_symlink_home ".gitconfig"
create_symlink_home ".zshrc"

echo -e "\033[1;32mInstallation complete. Restart shell.\033[0m"
