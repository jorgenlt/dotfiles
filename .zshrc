# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

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

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Configure the editor for Bundler and general use
export BUNDLER_EDITOR=code
export EDITOR=code

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Init homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Load pyenv (to manage your Python versions)
source $HOME/dotfiles/pyenv.sh

# Load rbenv if installed (to manage your Ruby versions)
source $HOME/dotfiles/rbenv.sh

# Load nvm (to manage your node versions)
source $HOME/dotfiles/nvm.sh

# Load Rails config
source $HOME/dotfiles/rails.sh

# Load MongoDB manager script
source $HOME/dotfiles/mongodb_manager.sh

# Load custom aliases
source "$HOME/dotfiles/aliases.sh"

# Load custom functions
source "$HOME/dotfiles/functions.sh"

# Set the Android SDK path
export ANDROID_HOME="${HOME}/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"

# Load Starship prompt. https://starship.rs/
eval "$(starship init zsh)"

# starship.toml moved to dotfiles folder
export STARSHIP_CONFIG=$HOME/dotfiles/starship.toml

# Enable syntax highlighting in the current interactive shell:
source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
