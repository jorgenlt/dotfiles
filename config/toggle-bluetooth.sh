#!/bin/bash

if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
    notify-send -i bluetooth "Bluetooth" "Off"
else
    bluetoothctl power on
    notify-send -i bluetooth "Bluetooth" "On"
fi

# Play notification sound
aplay -q /home/jlt/dotfiles/config/sounds/pop.wav
