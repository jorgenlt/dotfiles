# Set the ZSH variable to the path of the Oh-My-Zsh directory
ZSH=$HOME/.oh-my-zsh

# Themes
# https://github.com/robbyrussell/oh-my-zsh/wiki/themes
# ZSH_THEME="robbyrussell"
# Load Starship prompt. https://starship.rs/
eval "$(starship init zsh)"

# Plugins
plugins=(
  git 
  gitfast 
  last-working-dir 
  common-aliases 
  zsh-syntax-highlighting 
  history-substring-search 
  ssh-agent 
  command-not-found 
  sudo 
  zsh-autosuggestions 
  web-search 
  copypath 
  copyfile 
  copybuffer 
  dirhistory 
  history 
  z
)

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)
unalias lt # we need `lt` for https://github.com/localtunnel/localtunnel

# Aliases stored in the .aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Load rbenv if installed (to manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (to manage your Python versions)
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init - 2> /dev/null)" && RPROMPT+='[🐍 $(pyenv version-name)]'

# Load nvm (to manage your node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

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

# Define functions for managing MongoDB services
function status() {
    if [ "$1" = "mongod" ]; then
        sudo systemctl status mongod
    else
        echo "Invalid service specified."
    fi
}

function start() {
    if [ "$1" = "mongod" ]; then
        sudo systemctl start mongod
    else
        echo "Invalid service specified."
    fi
}

function enable() {
    if [ "$1" = "mongod" ]; then
        sudo systemctl enable mongod
    else
        echo "Invalid service specified."
    fi
}

function stop() {
    if [ "$1" = "mongod" ]; then
        sudo systemctl stop mongod
    else
        echo "Invalid service specified."
    fi
}

# Old commands
# export ZDOTDIR=/dotfiles
