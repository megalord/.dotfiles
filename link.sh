#!/bin/bash

CONFIG="~/.config"

for f in $(find . -maxdepth 1 -type f -name '.*'); do
  ln -s $PWD/$f ~/$f
done

mkdir -p ~/.config
for f in $(cd config && find . -mindepth 1 -maxdepth 1); do
  ln -s $PWD/config/$f $CONFIG/$f
done

if [ ! -d elenapan-dotfiles ]; then
  git clone https://github.com/elenapan/dotfiles elenapan-dotfiles
  ln -s $PWD/elenapan-dotfiles/config/awesome/themes/lovelace $PWD/config/awesome/themes/lovelace
  ln -s $PWD/elenapan-dotfiles/config/awesome/noodle $PWD/config/awesome/noodle
fi

sudo dnf install $(grep '^[^#]' packages)
