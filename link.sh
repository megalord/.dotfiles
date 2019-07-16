#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

for f in $(cd $SCRIPTPATH && find . -maxdepth 1 -type f -name '.*' -printf '%P\n'); do
  ln -sf $SCRIPTPATH/$f ~/$f
done

mkdir -p ~/.config
for d in $(cd $SCRIPTPATH/config && find * -maxdepth 0 -type d); do
  ln -sf $SCRIPTPATH/config/$d ~/.config/$d
done

if [ ! -d $SCRIPTPATH/elenapan-dotfiles ]; then
  git clone https://github.com/elenapan/dotfiles elenapan-dotfiles
  ln -sf $PWD/elenapan-dotfiles/config/awesome/themes/lovelace $PWD/config/awesome/themes/lovelace
  ln -sf $PWD/elenapan-dotfiles/config/awesome/noodle $PWD/config/awesome/noodle
fi

#sudo dnf install $(grep '^[^#]' packages)
