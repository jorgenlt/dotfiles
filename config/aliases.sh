#!/bin/bash

# System
alias rm="rm -v"
alias fa="find . | grep -i" # Find all. Files and folders. Case insensitive.
alias duc="du -sh ./" # Disk usage current directory
alias lf="ls -d1 */" # List all folders in currrent directory

# System information
alias about="fastfetch"
alias neofetch="fastfetch -c neofetch"
alias hardware="sudo lshw"
alias cpu="cpu_temp"
alias temps="watch -n 2 sensors"
alias nvidia="watch -n 2 nvidia-smi"
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"

# System update
alias u="$DOT/config/update.sh"
alias ur="u && reboot"
alias us="u && poweroff"

# Apps
alias ai="node ~/simple-ai-cli"

# Get External IP / Internet Speed
alias myip="curl -s  https://ipinfo.io/json | jq" 

# Fix Brave not rendering elements correct
alias brave-fix="rm -rf $HOME/.config/BraveSoftware/Brave-Browser/Default/GPUCache"

# Use discrete GPU
alias dgpu="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"

# Development aliases
alias c="code ."
alias dev="npm run dev"

# git / github
alias b="gh browse"
alias gpom="git pull origin master"
alias gs="git status"

# bat (a cat clone with syntax highlighting and Git integration)
alias bat="batcat"


