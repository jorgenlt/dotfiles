#!/bin/bash

# Function to print a colored header
print_header() {
  echo -e "\n\e[1;32m$1\e[0m"
}

# Update APT package index, upgrade the packages and then clean up old packages
print_header "UPDATING APT PACKAGE INDEX"
sudo apt update

print_header "UPGRADING APT PACKAGES"
sudo apt upgrade -y --allow-downgrades

print_header "CLEANING UP OLD APT PACKAGES"
sudo apt autoremove -y

# Update SNAP packages
print_header "UPDATING SNAP PACKAGES"
sudo snap refresh

# Update FLATPAK packages
print_header "UPDATING FLATPAK PACKAGES"
flatpak update -y

# Update Homebrew package index, upgrade the packages and then clean up old packages
print_header "UPDATING HOMEBREW PACKAGE INDEX"
brew update

print_header "UPGRADING HOMEBREW PACKAGES"
brew upgrade

print_header "CLEANING UP OLD HOMEBREW PACKAGES"
brew cleanup
echo "Cleanup complete."

sleep 1

print_header "* * * UPDATE COMPLETE * * *"

sleep 1
