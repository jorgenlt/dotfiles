#!/bin/bash

notify-send -i pop-os "Power Off" "Shutting down the system"

aplay -q /home/jlt/dotfiles/config/sounds/pop.wav

sleep 1

poweroff
