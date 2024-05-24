# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Path to dotfiles
export DOT="$HOME/dotfiles"

# Plugins
plugins=(
  aliases
  colored-man-pages
  command-not-found
  common-aliases
  # copybuffer
  # copyfile
  # copypath
  # dirhistory
  extract
  git
  gitfast
  history
  history-substring-search
  last-working-dir
  ssh-agent
  sudo
  web-search
  z
  zsh-autosuggestions
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

# Load custom aliases
source "$DOT/config/aliases.sh"

# Load custom functions
source "$DOT/config/functions.sh"

# Set Android SDK config
source "$DOT/config/android-sdk.sh"

# Load Starship
source "$DOT/config/starship.sh"

# Enable syntax highlighting in the current interactive shell
source "$HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
