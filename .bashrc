# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
export GOPATH="$HOME/.go"
export PATH="$HOME/.local/bin:$PATH:$GOPATH/bin"

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
for f in ~/.bashrc.*; do
  . $f
done

set -o vi
shopt -s globstar
unset command_not_found_handle

export TILLER_NAMESPACE=tesla-staging

export HISTSIZE=10000
export EDITOR=nvim

alias oc-docs='xdg-open https://docs.okd.io/3.6'

function oc-project () {
  oc project | awk -F\" '{print $2}'
}

function oc-open-project () {
  xdg-open $(oc project | awk -F\" '{print $4 "/console/project/" $2}')
}

function oc-secret () {
  oc get secrets/$1 -o json | jq -r ".data[\"$2\"]" | base64 -D
}

function oc-events () {
  if [ $# -eq 0 ]; then
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
function header () {
  grep -i $1 | sed -e 's/[^:]*: \(.*\)/\1/'
}
alias query_param='python3 -c "
import sys
from urllib.parse import parse_qs, urlparse
for val in parse_qs(urlparse(sys.stdin.read()).query).get(sys.argv[1], []):
  print(val)
"'

export NVM_DIR="$HOME/.nvm"
alias nvm-setup='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'  # This loads nvm

# tmux
alias tmuxa='tmux attach-session -t'
alias tmuxl='tmux list-sessions'

alias xc='xargs curl'

alias rm-pyc='find . -name "*.pyc" -exec rm -rf {} \;'

alias tf='terraform'

function repo-url () {
  remotes=$(git remote -v | awk '{print $1}' | uniq)
  remote="origin"
  if [[ $remotes =~ "upstream" ]]; then
    remote="upstream"
  fi
  git remote get-url $remote | sed -e 's/.*@\(.*\)\.git.*/\1/' -e 's/:/\//' -e 's/^/https:\/\//'
}

function repo () {
  xdg-open $(repo-url)
}

function prs () {
  xdg-open "$(repo-url)/pulls"
}

function new-session () {
  tmux new-session -d -s $1 -c $2 -n nvim
  tmux select-window -t $1:0
  tmux send-keys -t $1:0 'nvim' C-m
  tmux -2 attach-session -t $1
}

alias pystdlib='cd /usr/lib64/python3.7'

function gostdlib () {
  cd /usr/lib/golang/src
}

function goimports () {
  go list -f '{{join .Imports "\n"}}' $@ | sort | uniq
}
