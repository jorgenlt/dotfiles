# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Path to dotfiles
export DOT="$HOME/dotfiles"

# Plugins (https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
plugins=(
  aliases             # List the shortcuts that are currently available
  colored-man-pages   # Adds colors to man pages
  command-not-found   # Suggests packages to be installed if a command cannot be found
  common-aliases      # Creates helpful shortcut aliases for many commonly used commands
  copyfile            # Puts the contents of a file in your system clipboard
  dirhistory          # Adds keyboard shortcuts for navigating directory history and hierarchy. Alt + arrows.
  extract             # Extracts any archive file you pass it
  git                 #  Git aliases and a few useful functions
  gitfast             # Adds completion for Git
  history             # Provides convenient aliases for using the history command
  last-working-dir    # Keeps track of the last used working directory
  ssh-agent           # Set up and load whichever credentials you want for ssh connections
  sudo                # Prefix your current or previous commands with sudo by pressing esc twice
  web-search          # Adds aliases for searching with Google, Wiki, Bing, YouTube and other popular services
  z                   # Tracks your most visited directories, easy access with z <foldername>
  zsh-autosuggestions # Provides suggestions of commands based on history
)

# Load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"

# Set terminal config
source "$DOT/config/terminal-config.sh"

# Load homebrew
source "$DOT/config/homebrew.sh"

# Load pyenv
source "$DOT/config/pyenv.sh"

# Load rbenv
source "$DOT/config/rbenv.sh"

# Load nvm
source "$DOT/config/nvm.sh"

# Load Rails config
source "$DOT/config/rails.sh"

# Load MongoDB manager script
source "$DOT/config/mongodb-manager.sh"

# Load aliases
source "$DOT/config/aliases.sh"

# Load functions
source "$DOT/config/functions.sh"

# Set Android SDK config
source "$DOT/config/android-sdk.sh"

# Load Starship
source "$DOT/config/starship.sh"

# Enable syntax highlighting in the current interactive shell
source "$HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
