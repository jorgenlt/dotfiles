#!/bin/bash

# Add this script to startup applications to set power profile to battery life

system76-power profile battery

notify-send -i preferences-system-power "Power settings" "Battery Life"

# Play notification sound
aplay -q /home/jlt/dotfiles/config/sounds/notification.wav
