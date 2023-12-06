#!/bin/bash

# Get External IP / Internet Speed
alias myip="curl https://ipinfo.io/json" # or /ip for plain-text ip

# Quickly serve the current directory as HTTP
alias serve='ruby -run -e httpd . -p 8000' # Or python -m SimpleHTTPServer :)

# Laptop battery information
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"

# ChatGPT nodejs
alias gpt="$HOME/nodejs-chatgpt/run-chatgpt.sh"

# Update apt and snap packages
alias u="$HOME/dotfiles/update.sh"
alias ur="u && reboot"
alias us="u && poweroff"

# Fix Brave not rendering elements correct
alias brave-fix="rm -rf $HOME/.config/BraveSoftware/Brave-Browser/Default/GPUCache"

# CPU temperatures / sensors
alias cpu="$HOME/dotfiles/cpu-temp.sh"
alias temps="watch -n 2 sensors"

# GPU Sensor
alias nvidia="watch -n 2 nvidia-smi"

# Use discrete GPU
alias dgpu="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
# code .
alias c="code ."

# npm run dev
alias dev="npm run dev"

# git / github
alias b="gh browse"
alias gpom="git pull origin master"

# hardware information
alias hardware="sudo lshw"

