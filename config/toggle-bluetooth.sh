#!/bin/bash
# Check if Bluetooth is blocked
# rfkill list
# If soft blocked, unblock it with
# sudo rfkill unblock bluetooth

if rfkill list bluetooth | grep -q "Blocked: yes"; then
    rfkill unblock bluetooth
    notify-send -i bluetooth "Bluetooth" "Unblocked"
fi

if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
    notify-send -i bluetooth "Bluetooth" "Off"
else
    bluetoothctl power on
    notify-send -i bluetooth "Bluetooth" "On"
fi

# Play notification sound
aplay -q /home/jlt/dotfiles/config/sounds/pop.wav
