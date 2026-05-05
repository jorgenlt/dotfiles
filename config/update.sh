#!/bin/bash

# Function to print a colored header
print_header() {
  echo -e "\n\e[1;32m$1\e[0m"
}

detect_machine_type() {
  if ls /sys/class/power_supply 2>/dev/null | grep -qE '^BAT'; then
    echo "Laptop"
    return 0
  fi
  echo "Desktop"
}

get_current_power_profile() {
  system76-power profile | grep "Power Profile:" | awk '{print $3}' | tr '[:upper:]' '[:lower:]'
}

restore_power_profile() {
  local original_profile="$1"
  if [ -n "$original_profile" ]; then
    print_header "RESTORING POWER PROFILE TO: $original_profile"
    system76-power profile "$original_profile"
  fi
}

TYPE=$(detect_machine_type)

# Save current power profile and set to Performance if laptop
ORIGINAL_PROFILE=""
if [ "$TYPE" = "Laptop" ]; then
  ORIGINAL_PROFILE=$(get_current_power_profile)
  print_header "CURRENT POWER PROFILE: $ORIGINAL_PROFILE → SWITCHING TO PERFORMANCE"
  system76-power profile performance
fi

# Set power profile to Performance
if [ "$TYPE" = "Laptop" ]; then
  system76-power profile performance
fi

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

# - JOPLIN APP -
# Update the Joplin app
print_header "UPDATING JOPLIN"
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

# - PIP -
# Update pip
print_header "UPDATING PIP"
pip install --upgrade pip

# - YT-DLP -
# Update yt-dlp (https://github.com/yt-dlp/yt-dlp)
print_header "UPDATING YT-DLP"
python3 -m pip install -U "yt-dlp[default]"

print_header "* * * UPDATE COMPLETE * * *"

# Restore original power profile
if [ "$TYPE" = "Laptop" ]; then
  restore_power_profile "$ORIGINAL_PROFILE"
fi

# Notification
notify-send -i pop-os "System update" "Update complete"

# Play notification sound
aplay -q $DOT/config/sounds/notification.wav
