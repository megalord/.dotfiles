# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
ZSH_HIGHLIGHT_STYLES[globbing]=none

# display command's exit code
RPROMPT='[%?]'

bindkey "^R" history-incremental-search-backward

# fixes Emacs' terminal emulator
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color

export GOPATH="$HOME/.go"
export PATH="$PATH:$HOME/.local/bin:$GOPATH/bin"

export EDITOR=nvim

export LSCOLORS=GxFxCxDxBxegedabagaced

oc-project () {
  open $(oc project | awk -F\" '{print $4 "/console/project/" $2}')
}

alias d='docker'
alias dm='docker-machine'
alias dc='docker-compose'
alias d-clean-images='d images | grep "<none>" | awk "{print $3}" | xargs docker rmi'
alias d-setup='eval $(dm env)'
alias d-setup-local='
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://localhost:2376"
export DOCKER_CERT_PATH="/Users/jord7580/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
'

alias urldecode='python3 -c "import sys; from urllib.parse import unquote; print(unquote(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read()))"'
alias urlencode='python3 -c "import sys; from urllib.parse import quote; print(quote(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read()))"'
alias inflate='python3 -c "import sys, zlib; print(zlib.decompress(sys.stdin.buffer.read(), -15).decode(\"utf-8\"))"'
alias deflate='python3 -c "import sys, zlib; print(zlib.compress(sys.stdin.buffer.read())[2:-4])"'
header () { grep -i $1 | sed -e 's/[^:]*: \(.*\)/\1/' }
alias query_param='python3 -c "
import sys
from urllib.parse import parse_qs, urlparse
for val in parse_qs(urlparse(sys.stdin.read()).query).get(sys.argv[1], []):
  print(val)
"'
alias saml-request='header location | query_param SAMLRequest | urldecode | base64 -D'
alias saml-request-deflated='header location | query_param SAMLRequest | urldecode | base64 -D | inflate'

export NVM_DIR="/Users/jord7580/.nvm"
alias nvm-setup='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'  # This loads nvm

# rbenv
alias rbenv-setup='eval "$(rbenv init -)"'

# bundler
alias be='bundle exec'

# tmux
alias tmuxa='tmux attach-session -t'
alias tmuxl='tmux list-sessions'

alias xc='xargs curl'

alias rm-pyc='find . -name "*.pyc" -exec rm -rf {} \;'

upstream-url () {
  git remote -v | grep upstream | sed -n '2 p' | sed -e 's/.*@\(.*\)\.git.*/\1/' -e 's/:/\//' -e 's/^/https:\/\//'
}

repo () {
  open $(upstream-url)
}

prs () {
  open "$(upstream-url)/pulls"
}

new-session () {
  tmux new-session -d -s $1 -c $2 -n nvim
  tmux select-window -t $1:0
  tmux send-keys -t $1:0 'nvim' C-m
  tmux -2 attach-session -t $1
}

gostdlib () {
  cd /usr/local/Cellar/go/1.8/libexec
}

goimports () {
  go list -f '{{join .Imports "\n"}}' $@ | sort | uniq
}

source ~/.raxrc
