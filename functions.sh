#!/bin/bash

# Function to suspend the system
suspend_system() {
    local total_minutes=$1
    local total_seconds=$((total_minutes * 60))
    local hours minutes seconds

    while [ $total_seconds -gt 0 ]; do
        ((hours=$total_seconds/3600))
        ((minutes=($total_seconds%3600)/60))
        ((seconds=$total_seconds%60))

        printf "System will sleep in %02d:%02d:%02d\r" $hours $minutes $seconds
        sleep 1
        ((total_seconds--))
    done

    sudo systemctl suspend
}

# Function to shut down the system
shutdown_system() {
    local total_minutes=$1
    local total_seconds=$((total_minutes * 60))
    local hours minutes seconds

    while [ $total_seconds -gt 0 ]; do
        ((hours=$total_seconds/3600))
        ((minutes=($total_seconds%3600)/60))
        ((seconds=$total_seconds%60))

        printf "System will shut down in %02d:%02d:%02d\r" $hours $minutes $seconds
        sleep 1
        ((total_seconds--))
    done

    sudo shutdown now
}
