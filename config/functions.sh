#!/bin/bash

# Function to display the countdown timer
display_countdown() {
  local total_seconds=$1
  local hours minutes seconds

  while [ $total_seconds -gt 0 ]; do
    ((hours = $total_seconds / 3600))
    ((minutes = ($total_seconds % 3600) / 60))
    ((seconds = $total_seconds % 60))

    printf "%02d:%02d:%02d\r" $hours $minutes $seconds
    sleep 1
    ((total_seconds--))
  done
}

# Function to suspend the system
suspend_system() {
  local total_minutes=$1
  local total_seconds=$((total_minutes * 60))

  echo "System will sleep in:"
  display_countdown $total_seconds

  sudo systemctl suspend
}

# Function to shut down the system
shutdown_system() {
  local total_minutes=$1
  local total_seconds=$((total_minutes * 60))

  echo "System will shut down in:"
  display_countdown $total_seconds

  sudo shutdown now
}

# Function to get the CPU temperature
cpu_temp() {
  sensors k10temp-pci-00c3 | grep Tctl | awk '{print $2}'
}

# Function to cat files
catfile() {
  case "$1" in
  *.pdf)
    pdftotext "$1" -
    ;;
  *.ods | *.odt)
    odt2txt "$1"
    ;;
  *.docx)
    temp_file=$(mktemp)
    docx2txt "$1" "$temp_file"
    cat "$temp_file"
    rm "$temp_file"
    ;;
  *.xlsx)
    xlsx2csv "$1" | sed 's/,/\t/g' | cat
    ;;
  *)
    cat "$1"
    ;;
  esac
}

# Function to git add -> commit –> push
gacp() {
  # Accept two arguments: message and origin (with "master" as default)
  local message="$1"
  local origin="${2:-master}"  # Use "master" as default if second argument is not provided

  # Run the git commands using the provided arguments
  git add . && git commit -m "$message" && git push origin "$origin"
}
