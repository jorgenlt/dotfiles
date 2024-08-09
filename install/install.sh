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
    sleep 1
    echo "Opening installation URL"
    sleep 1
    open "$install_url"
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
    echo
    sleep 1
    echo "Opening installation URL"
    sleep 1
    open "$install_url"
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
check_command code "VS Code" "https://code.visualstudio.com/download"
check_command vivaldi "Vivaldi" "https://vivaldi.com/download/"

# Check if GitHub CLI is installed and install if not
if ! command -v gh &>/dev/null; then
  echo "GitHub CLI is not installed. Starting installation..."
  echo
  (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y))
  sudo mkdir -p -m 755 /etc/apt/keyrings
  wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install gh -y
else
  echo "GitHub CLI ✅"
fi
echo

# Check if dotfiles folder exist and clone from repo if not
if [ -d "$HOME/dotfiles" ]; then
  echo "Dotfiles repo ✅"
else
  echo "Dotfiles repo does not exist. Cloning repo..."
  echo
  gh auth login
  gh repo clone jorgenlt/dotfiles
fi
echo

# Check if Starship is installed and install if not
if ! command -v starship &>/dev/null; then
  echo "Starship is not installed. Starting installation..."
  echo
  curl -sS https://starship.rs/install.sh | sh
else
  echo "Starship ✅"
fi
echo

# Check if Diodon is installed and install if not
if ! command -v diodon &>/dev/null; then
  echo "Diodon is not installed. Starting installation..."
  echo
  sudo add-apt-repository ppa:diodon-team/stable
  sudo apt-get update
  sudo apt-get install -y diodon
else
  echo "Diodon ✅"
fi
echo

# Check if Rclone is installed and install if not
if ! command -v rclone &>/dev/null; then
  echo "Rclone is not installed. Starting installation..."
  echo
  sudo -v ; curl https://rclone.org/install.sh | sudo bash
else
  echo "Rclone ✅"
fi
echo

# Check if Zsh is installed and install if not
if ! command -v zsh &>/dev/null; then
  echo "Zsh is not installed. Starting installation..."
  echo
  sudo apt update
  sudo apt install -y zsh
  echo
  echo "Zsh was installed, rebooting system"
  sleep 1
  reboot
else
  echo "Zsh ✅"
fi
echo

# Check if Oh My Zsh is installed and install if not
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh ✅"
else
  echo "Oh My Zsh is not installed. Starting installation..."
  echo
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
echo

# Check if Input Remapper is installed
check_directory "$HOME/.config/input-remapper-2" "Input Remapper" "https://github.com/sezanzeb/input-remapper/releases"

# If Input Remapper preset folder for LAPTOP exists, run a script to create the appropriate symlink
if [ -d "$HOME/.config/input-remapper-2/presets/AT Translated Set 2 keyboard" ]; then
  $DOT/config/remapper/create-symlink-laptop.sh
else
  echo "Input Remapper preset folder for laptop does not exist. ℹ️"
fi
echo

# If Input Remapper preset folder for DESKTOP exists, run a script to create the appropriate symlinks
if [ -d "$HOME/.config/input-remapper-2/presets/Ducky Ducky One2 Mini" ]; then
  $DOT/config/remapper/create-symlink-desktop.sh
else
  echo "Input Remapper preset folder for desktop does not exist. ℹ️"
fi
echo

# Check if FiraCode Nerd Font Mono is installed
if ! fc-list | grep -iq 'firacode nerd font mono'; then
  echo "FiraCode Nerd Font is not installed."
  echo "https://www.nerdfonts.com/font-downloads"
  echo "Installation cancelled."
  echo
  sleep 1
  echo "Opening installation URL"
  sleep 1
  open "https://www.nerdfonts.com/font-downloads"
  exit 1
else
  echo "FiraCode Nerd Font Mono ✅"
fi
echo

# Create symlinks in home folder
create_symlink_home ".gitconfig"
create_symlink_home ".zshrc"

echo -e "\033[1;32m* * * Installation complete. Restart system. * * *\033[0m"
echo
