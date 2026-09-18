#!/usr/bin/env bash

export DISPLAY=:0
export XAUTHORITY=/home/jlt/.Xauthority
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
export XDG_RUNTIME_DIR=/run/user/1000

# notify-send -i pop-os "share-numpad.sh"

playerctl play-pause

