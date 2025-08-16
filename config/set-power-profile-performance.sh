#!/bin/bash

system76-power profile performance

notify-send -i preferences-system-power "Power settings" "Performance"

# Play notification sound
aplay -q /home/jlt/dotfiles/config/sounds/pop.wav
