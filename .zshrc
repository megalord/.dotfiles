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

export TILLER_NAMESPACE=tesla-staging

export EDITOR=nvim

export LSCOLORS=GxFxCxDxBxegedabagaced

alias oc-docs='open https://docs.openshift.org/1.5/welcome/index.html'

oc-project () {
  oc project | awk -F\" '{print $2}'
}

oc-open-project () {
  open $(oc project | awk -F\" '{print $4 "/console/project/" $2}')
}

oc-secret () {
  oc get secrets/$1 -o json | jq -r ".data[\"$2\"]" | base64 -D
}

oc-events () {
  if [ $# -eq 0 ];
  then
    query=''
  else
    query="?fieldSelector=involvedObject.name%3D$1"
  fi
  curl -sk -H "accept: application/json" -H "Authorization: Bearer $(oc whoami -t)" "$(oc project | awk -F\" '{print $4 "/api/v1/namespaces/" $2}')/events$query" | jq -r '.items[] | "\(.firstTimestamp) [\(.source.host)]: \(.message)"'
}

alias d='docker'
alias dc='docker-compose'
alias d-clean-images='d images | grep "<none>" | awk "{print $3}" | xargs docker rmi'

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

alias tf='terraform'

repo-url () {
  remotes=$(git remote -v | awk '{print $1}' | uniq)
  remote="origin"
  if [[ $remotes =~ "upstream" ]]; then
    remote="upstream"
  fi
  git remote get-url $remote | sed -e 's/.*@\(.*\)\.git.*/\1/' -e 's/:/\//' -e 's/^/https:\/\//'
}

repo () {
  open $(repo-url)
}

prs () {
  open "$(repo-url)/pulls"
}

new-session () {
  tmux new-session -d -s $1 -c $2 -n nvim
  tmux select-window -t $1:0
  tmux send-keys -t $1:0 'nvim' C-m
  tmux -2 attach-session -t $1
}

alias pystdlib='/usr/local/Cellar/python3/3.6.5/Frameworks/Python.framework/Versions/3.6/lib/python3.6'

gostdlib () {
  cd /usr/local/Cellar/go/1.8/libexec/src
}

goimports () {
  go list -f '{{join .Imports "\n"}}' $@ | sort | uniq
}

source ~/.raxrc
