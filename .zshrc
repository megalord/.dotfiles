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

# display command's exit code
RPROMPT='[%?]'

export PATH="$PATH:/usr/local/smlnj/bin"

export EDITOR=vim

export LSCOLORS=GxFxCxDxBxegedabagaced

# rbenv
eval "$(rbenv init -)"

# bundler
alias be='bundle exec'

# tmux
alias tmuxa='tmux attach-session -t'
alias tmuxl='tmux list-sessions'

# watch more files
launchctl limit maxfiles 2048 2048 && ulimit -n 2048
