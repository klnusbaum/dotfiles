curdir=$(pwd)
git_conf_path="$curdir/git_config_common"
git config --global include.path "$git_conf_path"

echo "source $curdir/bash_common" >> $HOME/.bash_profile

mkdir -p $HOME/.config/nvim
ln -s vim_conf $HOME/.config/nvim/init.vim

ln -s tmux.conf $HOME/.tmux.conf

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
