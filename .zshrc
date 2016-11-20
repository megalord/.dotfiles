#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
ZSH_HIGHLIGHT_STYLES[globbing]=none

# display command's exit code
RPROMPT='[%?]'

# fixes Emacs' terminal emulator
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color

export PATH="$PATH:$HOME/.local/bin"

export EDITOR=nvim

export LSCOLORS=GxFxCxDxBxegedabagaced


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

no-quotes () {
  sed 's/\"//g'
}

cred-pass () {
  jq '.credential.password'
}

ss-local-user () {
  soil pwsafe production GET /projects/1519/credentials/75357 | xc -H 'Accept: application/json' | cred-pass | no-quotes
}

ss-prod-db-read () {
  soil pwsafe production GET /projects/1651/credentials/9836 | xc -H 'Accept: application/json' | cred-pass | no-quotes
}

ss-stag-db-read () {
  soil pwsafe production GET /projects/1349/credentials/9200 | xc -H 'Accept: application/json' | cred-pass | no-quotes
}

ctk-result () {
  jq '.[0] | .result[0]'
}

lookup-sku () {
  soil ctk production post / | xc --data "[{\"class\":\"Product.Product\",\"load_arg\":$1,\"attributes\":[\"active\",\"name\",\"description\"]}]" | ctk-result
}

lookup-device () {
  soil ctk production post / | xc --data "[{\"class\":\"Computer.Computer\",\"load_arg\":$1,\"attributes\":[\"number\",\"name\",\"type\",\"customer_number.customer_number\",\"platform_type\",\"platform_model\",\"datacenter.symbol\",\"account.segment.name\",\"status.name\",\"platform.product_sku.sku\",\"parts.sku_number\",\"modified\",\"children\",\"parents\"]}]" | ctk-result
}

maestro-logs () {
  soil maestro staging get /environments/$1/logs | xc -k | jq '.[] | to_entries[] | .key + .value'
}

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
