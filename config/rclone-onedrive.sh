#!/bin/bash

# Add this script to startup applications to mount OneDrive

rclone --vfs-cache-mode writes mount onedrive: ~/onedrive &

# Wait for a moment to ensure the mount process has started
sleep 5

# Check if OneDrive is mounted
if mount | grep ~/onedrive >/dev/null; then
  notify-send "OneDrive connected." "Microsoft OneDrive successfully mounted."
else
  notify-send "OneDrive connection failed." "Failed to mount Microsoft OneDrive."
fi
