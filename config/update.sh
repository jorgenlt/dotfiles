#!/bin/bash

# Function to print a colored header
print_header() {
  echo -e "\n\e[1;32m$1\e[0m"
}

# Set power profile to High Performance
system76-power profile performance

# - APT -
# Update APT package index
print_header "UPDATING APT PACKAGE INDEX"
sudo apt update

# Upgrade if there are updates available and cleanup after
if [ $(apt list --upgradable 2>/dev/null | wc -l) -gt 1 ]; then
  print_header "UPGRADING APT PACKAGES"
  sudo apt upgrade -y --allow-downgrades

  print_header "CLEANING UP OLD APT PACKAGES"
  sudo apt autoremove -y
else
  echo
  echo "No packages to upgrade."
fi

# - SNAP -
# Update SNAP packages
if command -v snap &>/dev/null; then
  print_header "UPDATING SNAP PACKAGES"
  sudo snap refresh
fi

# - FLATPAK -
# Update FLATPAK packages
print_header "UPDATING FLATPAK PACKAGES"
flatpak update -y

# - HOMEBREW -
# Update Homebrew package index
print_header "UPDATING HOMEBREW PACKAGE INDEX"
brew update

# Upgrade Homebrew packages if there are updates available and run cleanup after
if [ $(brew outdated --formula | wc -l) -gt 0 ]; then
  print_header "UPGRADING HOMEBREW PACKAGES"
  brew upgrade

  print_header "CLEANING UP OLD HOMEBREW PACKAGES"
  brew cleanup
  echo "Cleanup complete."
else
  echo
  echo "No updates available for Homebrew packages."
fi

# Set power profile to Battery Life
system76-power profile battery

print_header "* * * UPDATE COMPLETE * * *"
