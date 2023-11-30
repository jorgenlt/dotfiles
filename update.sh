#!/bin/bash

print_header() {
  echo -e "\n\e[1;32m$1\e[0m"
}

# Function to update packages
update_packages() {
  print_header "UPDATING $1 PACKAGES"
  sudo $2 $3
}

# Update APT package index and then upgrade the packages
print_header "UPDATING APT PACKAGE INDEX"
sudo apt update

print_header "UPGRADING APT PACKAGES"
sudo apt upgrade -y

# Update SNAP packages
print_header "UPDATING SNAP PACKAGES"
sudo snap refresh

# Update FLATPAK packages
print_header "UPDATING FLATPAK PACKAGES"
flatpak update -y

sleep 1

print_header "* * * UPDATE COMPLETE * * *"

sleep 1
