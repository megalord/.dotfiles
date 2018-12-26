#!/bin/bash
for f in $(find . -maxdepth 1 -type f -name '.*'); do
  ln -s ~/.dotfiles/$f ~/$f
done

mkdir -p ~/.config
for f in $(cd config && find . -mindepth 1 -maxdepth 1); do
  ln -s ~/.dotfiles/config/$f ~/.config/$f
done

sudo dnf install $(grep '^[^#]' packages)
