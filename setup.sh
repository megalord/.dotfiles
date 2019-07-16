#!/bin/bash

# aspell aspell-en cmus ctags docker jq
packages_wanted=(firefox-developer-edition fzf git htop neovim openssh sway termite upower wl-clipboard)
aur_wanted=(bitwise)

message() {
  printf '\n'
  printf '#%.0s' {1..4}
  printf '#%.0s' $(seq 1 ${#1})
  printf '#%.0s' {1..4}
  printf '\n'

  printf '#%.0s' {1..3}
  printf ' %s ' $1
  printf '#%.0s' {1..3}
  printf '\n'

  printf '#%.0s' {1..4}
  printf '#%.0s' $(seq 1 ${#1})
  printf '#%.0s' {1..4}
  printf '\n'
}

groups | grep wheel > /dev/null
if [ $? != 0 ]; then
  echo "$USER is not part of wheel group\nrun 'usermod -aG wheel $USER' as root"
  exit 1
fi


message "Configuration"

base=${DOTFILES:-$PWD}
conf=${XDG_CONFIG_DIR:-$HOME/.config}

for f in $(find $base -maxdepth 1 -type f -name '.*'); do
  printf "Installing $(basename $f) ... "
  if [ ! -f "$HOME/$(basename $f)" ]; then
    ln -sf $f $HOME/$(basename $f)
    echo "done"
  else
    echo "skipped"
  fi
done

if [ ! -d "$conf" ]; then
  mkdir $conf
fi
for f in $(find $base/config -mindepth 1 -maxdepth 1); do
  printf "Installing $(basename $f) ... "
  if [ ! -d "$conf/$(basename $f)" ]; then
    ln -s $f $conf/$(basename $f)
    echo "done"
  else
    echo "skipped"
  fi
done

message "Packages"

packages_needed=''
for p in $packages_wanted; do
  pacman -Q $p > /dev/null
  if [ $? != 0 ]; then
    packages_needed="$packages_needed $p"
  fi
done
if [ ! -z "$packages_needed" ]; then
  echo "Found missing packages: $packages_needed"
  echo "Installing..."
  sudo pacman -S $packages_needed
else
  echo "All packages installed"
fi

aur_needed=''
for p in $aur_wanted; do
  pacman -Q $p > /dev/null
  if [ $? != 0 ]; then
    aur_needed="$aur_needed $p"
  fi
done
if [ ! -z "$aur_needed" ]; then
  echo "Found missing AUR packages: $aur_needed"
  echo "Installing..."
  for p in $aur_needed; do
    git clone https://aur.archlinux.org/$p.git $HOME/.aur/$p
    (cd $HOME/.aur/$p && makepkg -si)
  done
else
  echo "All AUR packages installed"
fi

printf "Installing vim-plug... "
if [ ! -f "$HOME/.nvim/autoload/plug.vim" ]; then
  curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim --create-dirs -sfLo $HOME/.nvim/autoload/plug.vim
  echo "done"
else
  echo "skipped"
fi
printf "Installing vim plugins... "
if [ ! -d "$HOME/.nvim/bundle" ]; then
  nvim -c PlugInstall
  echo "done"
else
  echo "skipped"
fi
