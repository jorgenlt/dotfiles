#!/bin/bash

system76-power profile battery

notify-send -i preferences-system-power "Power settings" "Battery Life"

# Play notification sound
aplay -q /home/jlt/dotfiles/config/sounds/pop.wav
