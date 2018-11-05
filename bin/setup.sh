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
   echo "Installing tree"
   brew install tree
   echo "Installing wget"
   brew install wget
}

if [ "$(uname)" = "Darwin" ]
then
  echo "Darwin detected. Installing necessary software"
  macinstall
fi

echo "Installing Plug for vim"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
