#!/bin/bash

set -e -u -o pipefail
brew install neovim tmux tree wget ripgrep imagemagick reattach-to-user-namespace
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall > /dev/null
