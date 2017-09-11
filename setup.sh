#!/bin/bash
ensurebrew () {
 if type brew 2>/dev/null
 then
   echo "Brew detected. No need to install"
 else
   echo "Brew not detected. Installing..."
   /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
 fi 
}


macinstall() {
   ensurebrew
   echo "Installing reattach-user-namespace"
   brew install reattach-to-user-namespace
   echo "Installing neovim"
   brew install neovim
   echo "Installing tmux"
   brew install tmux
}


if [ "$(uname)" = "Darwin" ]
then
  echo "Darwin detected. Installing necessary software"
  macinstall
fi

FILES_DIR=$(pwd $(dirname "${BASH_SOURCE[0]}"))

echo "Including common git config"
git_conf_path="$FILES_DIR/git_config_common"
git config --global include.path "$git_conf_path"

echo "Adding common bash config"
echo "source $FILES_DIR/bash_common" >> $HOME/.bash_profile

echo "Linking tmux config"
ln -s $FILES_DIR/tmux.conf $HOME/.tmux.conf

echo "Linking nvim config"
mkdir -p $HOME/.config/nvim
ln -s $FILES_DIR/vim_conf $HOME/.config/nvim/init.vim

echo "Installing Plug for vim"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
