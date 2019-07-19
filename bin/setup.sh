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
   echo "Installing python3"
   brew install python3
   echo "installing pynvim"
   pip3 install --user --upgrade pynvim
   echo "installing ripgrep"
   brew install ripgrep
   echo "installing imagemagick"
   brew install imagemagick
}

debinstall() {
    echo "Updating package list"
    sudo apt update

    echo "Upgrading packages"
    sudo apt upgrade

    echo "Installing extra packages"
    sudo apt install tree neovim tmux python3-pip ripgrep

    echo "Installing pynvim (for neovim)"
    pip3 install --user --upgrade pynvim

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

echo "Installing Rust"
curl -sf -L https://static.rust-lang.org/rustup.sh | sh
rustup component add rls rust-analysis rust-src


echo "Installing Plug for vim"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall > /dev/null

powerline_fonts
