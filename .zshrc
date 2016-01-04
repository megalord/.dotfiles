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

export PATH="$PATH:$HOME/.local/bin"

export EDITOR=nvim

export LSCOLORS=GxFxCxDxBxegedabagaced

# rbenv
eval "$(rbenv init -)"

# bundler
alias be='bundle exec'

# tmux
alias tmuxa='tmux attach-session -t'
alias tmuxl='tmux list-sessions'

# python
#export PIP_REQUIRE_VIRTUALENV=true
#PROMPT="$python_info[virtualenv] $PROMPT"

brew_prefix=$(brew --prefix)
alias ctags="$brew_prefix/bin/ctags"

no-quotes () {
  sed 's/\"//g'
}

cred-pass () {
  jq '.credential.password'
}

ss-local-user () {
  rax-api --prod pwsafe GET /projects/1519/credentials/75357 | cred-pass | no-quotes
}

ss-prod-db-read () {
  rax-api --prod pwsafe GET /projects/1651/credentials/9836 | cred-pass | no-quotes
}

ss-stag-db-read () {
  rax-api --prod pwsafe GET /projects/1349/credentials/9200 | cred-pass | no-quotes
}

new-session () {
  tmux new-session -d -s $1 -c $2 -n nvim
  tmux select-window -t $1:0
  tmux send-keys -t $1:0 'nvim' C-m
  tmux -2 attach-session -t $1
}
