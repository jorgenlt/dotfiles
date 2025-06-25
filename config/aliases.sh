#!/bin/bash

# System
alias cl="clear"
alias duc="du -sh ./"                                                     # Disk usage current directory
alias duf="du -sh * | sort -h"                                            # Disk usage files and folders, sorted by size
alias fa="find . | grep -i"                                               # Find all. Files and folders. Case insensitive.
alias fa1="find . -maxdepth 1 | grep -i"                                  # Find all. Files and folders. Maxdepth 1. Case insensitive.
alias fa2="find . -maxdepth 2 | grep -i"                                  # Find all. Files and folders. Maxdepth 2. Case insensitive.
alias fa3="find . -maxdepth 3 | grep -i"                                  # Find all. Files and folders. Maxdepth 3. Case insensitive.
alias fd1="find . -maxdepth 1 -type d -name"                              # Find directories, maxdepth 1
alias ff1="find . -maxdepth 1 -type f -name"                              # Find files, maxdepth 1
alias lf="ls -d1 */"                                                      # List all folders in currrent directory
alias o="open"                                                            # Open file, folder and URI in default application
alias rm="rm -v"                                                          # Add verbose to rm
alias rsync="rsync -r --info=progress2"                                   # Rsync with progress
alias q="exit"                                                            # Exit (close) terminal
alias wifi-reset="nmcli radio wifi off && sleep 1 && nmcli radio wifi on" # Reset WiFi

# System information
alias about="fastfetch"
alias neofetch="fastfetch -c neofetch"
alias hardware="sudo lshw"
alias cpu="cpu_temp"
alias temps="watch -n 2 sensors"
alias nvidia="watch -n 2 nvidia-smi"
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BATT"
alias wireless-info="lspci -vv -s 01:00.0"

# System update
alias u="$DOT/config/update.sh"
alias ur="u && reboot"
alias up="u && poweroff"

# Apps
alias ai="node ~/simple-ai-cli"
alias aij="node ~/simple-ai-cli javascript"
alias ail="node ~/simple-ai-cli linux"
alias aiu="node ~/simple-ai-cli ubuntu"
alias f="firefox"
alias is="is-fast"
alias mpv="flatpak run io.mpv.Mpv"
alias notify="aplay -q $DOT/config/sounds/notification.wav"
alias torrent="$DOT/config/search-torrents.sh"
alias st="speedtest"
alias tickrs="tickrs -x --summary -c candle -s AAPL,AMD,EEM,INTC,LIT,MSFT,NVDA,PYPL,TSM,SMH,SPY,QQQ"

# YT-DLP (https://github.com/yt-dlp/yt-dlp)
alias yt="cd ~/Videos && yt-dlp --write-subs -S 'ext'"                 # Download the best video with the best extension. Subs incl.
alias yt-1440="cd ~/Videos && yt-dlp --write-subs -S 'res:1440'"       # 1440p. Subs incl.
alias yt-1080="cd ~/Videos && yt-dlp --write-subs -S 'res:1080'"       # 1080p. Subs incl.
alias yt-720="cd ~/Videos && yt-dlp --write-subs -S 'res:720'"         # 720p. Subs incl.
alias yt-mp3="cd ~/Music && yt-dlp --extract-audio --audio-format mp3" # Download mp3 audio file.

# Get IP info
alias myip="curl -s  https://ipinfo.io/json | jq"

# Development aliases
alias c="code ."
alias dev="npm run dev"

# git / github
alias b="gh browse"
alias gpom="git pull origin master"
alias gs="git status"

# bat (a cat clone with syntax highlighting and Git integration)
alias bat="batcat"

# NAS
alias nas="/run/user/1000/gvfs/smb-share:server=personalcloud.local,share=public"
