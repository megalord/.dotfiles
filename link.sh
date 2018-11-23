#!/bin/bash
for f in $(find . -maxdepth 1 -type f); do
  if [[ "$f" == "link.sh" ]]; then
    continue
  elif [[ "$f" == "init.vim" ]]; then
    mkdir -p ~/.config/nvim
    ln -s ~/.dotfiles/init.vim ~/.config/nvim/init.vim
  else
    ln -s ~/.dotfiles/$f ~/$f
  fi
done
