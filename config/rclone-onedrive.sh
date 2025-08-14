#!/bin/bash

# Add this script to startup applications to mount OneDrive

rclone --vfs-cache-mode writes mount onedrive: ~/onedrive &

# Wait for a moment to ensure the mount process has started
sleep 5

# Check if OneDrive is mounted
if mount | grep ~/onedrive >/dev/null; then
  notify-send -i /usr/share/icons/Pop/48x48/places/folder-remote.svg "OneDrive connected." "Microsoft OneDrive successfully mounted."
else
  notify-send -i /usr/share/icons/Pop/48x48/status/dialog-error.svg "OneDrive connection failed." "Failed to mount Microsoft OneDrive."
fi
