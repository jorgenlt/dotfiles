#!/bin/bash

notify-send -i pop-os "Reboot" "Rebooting system"

aplay -q /home/jlt/dotfiles/config/sounds/pop.wav

sleep 1

reboot
