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

# Function to suspend the system by minutes
suspend_system() {
  local total_minutes=$1
  local total_seconds=$((total_minutes * 60))

  echo "System will sleep in:"
  display_countdown $total_seconds

  sudo systemctl suspend
}

# Function to suspend the system by battery level
suspend_system_battery() {
  local THRESHOLD=$1

  echo "\nSystem will sleep when the battery level is $THRESHOLD%\n"

  while true; do
    # Get the current battery percentage
    local BATTERY_LEVEL=$(upower -i $(upower -e | grep BAT) | awk '/percentage/ {print int($2)}')

    # Check if the battery level is less than or equal to the threshold
    if [ "$BATTERY_LEVEL" -le "$THRESHOLD" ]; then
      echo "\n"
      echo "Battery level is $THRESHOLD%, suspending the system...\n"
      notify-send "Battery threshold reached." "Suspending system in 1 minute."
      suspend_system 1
    fi

    printf "\rCurrent battery level: %s%%" "$BATTERY_LEVEL"

    # Wait for a minute before checking again
    sleep 60
  done
}

# Function to shut down the system
shutdown_system() {
  local total_minutes=$1
  local total_seconds=$((total_minutes * 60))

  echo "System will shut down in:"
  display_countdown $total_seconds

  sudo shutdown now
}

# Function to shut down the system by battery level
shutdown_system_battery() {
  local THRESHOLD=$1

  echo "\nSystem will shut down when the battery level is $THRESHOLD%\n"

  while true; do
    # Get the current battery percentage
    local BATTERY_LEVEL=$(upower -i $(upower -e | grep BAT) | awk '/percentage/ {print int($2)}')

    # Check if the battery level is less than or equal to the threshold
    if [ "$BATTERY_LEVEL" -le "$THRESHOLD" ]; then
      echo "\n"
      echo "Battery level is $THRESHOLD%, shutting down the system...\n"
      notify-send "Battery threshold reached." "Shutting down the system in 1 minute."
      shutdown_system 1
    fi

    printf "\rCurrent battery level: %s%%" "$BATTERY_LEVEL"

    # Wait for a minute before checking again
    sleep 60
  done
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
  local message="$1"
  local origin=$(git_current_branch)

  git add . && git commit -m "$message" && git push origin "$origin"
}
