#!/bin/bash

# Load Starship prompt. https://starship.rs/
eval "$(starship init zsh)"

# starship.toml moved to dotfiles folder
export STARSHIP_CONFIG="$DOT/config/starship.toml"

