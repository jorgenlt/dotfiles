# Set the ZSH variable to the path of the Oh-My-Zsh directory
ZSH=$HOME/.oh-my-zsh

# Load Starship prompt. https://starship.rs/
eval "$(starship init zsh)"

# starship.toml moved to dotfiles folder
export STARSHIP_CONFIG=$HOME/dotfiles/starship.toml

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

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)
unalias lt # we need `lt` for https://github.com/localtunnel/localtunnel

# Load custom aliases
source "$HOME/dotfiles/aliases.sh"

# Load rbenv if installed (to manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (to manage your Python versions)
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init - 2> /dev/null)" && RPROMPT+='[🐍 $(pyenv version-name)]'

# Load nvm (to manage your node versions)
source $HOME/dotfiles/nvm.sh

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Configure the editor for Bundler and general use
export BUNDLER_EDITOR=code
export EDITOR=code

# Set ipdb as the default Python debugger
export PYTHONBREAKPOINT=ipdb.set_trace

# Set the Android SDK path
export ANDROID_HOME="${HOME}/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"

# Load MongoDB manager script
source $HOME/dotfiles/mongodb_manager.sh

# Enable syntax highlighting in the current interactive shell:
source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Init homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
