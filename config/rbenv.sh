#!/bin/bash

export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Quickly serve the current directory as HTTP
alias serve='ruby -run -e httpd . -p 8000' # Or python -m SimpleHTTPServer :)