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
   echo "installing pynvim"
   pip3 install --user --upgrade pynvim
   echo "installing ripgrep"
   brew install ripgrep
}

debinstall() {
    sudo apt-get install tree neovim tmux ripgrep
}

powerline_fonts() {
    echo "Installing powerline fonts"
    echo "Remember to set your terminal font size to an odd number"
    echo "Preferred Font is \"Literation Mono\""
    git clone https://github.com/powerline/fonts.git --depth=1
    pushd fonts || exit
    ./install.sh
    popd || exit
    rm -rf fonts
}



if [ "$(uname)" = "Darwin" ]
then
  echo "Darwin detected. Installing necessary software"
  macinstall
elif [ "$(uname)" = "Linux" ]
then
  echo "Linux detected. Assuming Ubuntu/Debian"
  debinstall 
fi

echo "Installing Plug for vim"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

powerline_fonts
