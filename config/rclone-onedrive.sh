#!/bin/bash

# Set this script to run at startup to mount OneDrive

rclone --vfs-cache-mode writes mount onedrive: ~/onedrive &
notify-send "OneDrive connected." "Microsoft OneDrive successfully mounted."
