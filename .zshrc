[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH=$HOME/bin:$HOME/kopt/bin:$HOME/kopt/work/bin:$HOME/google-cloud-sdk/bin:$PATH
export EDITOR=vim
export GOPATH=$HOME/sandbox/go-code
bindkey -e

eval "$(direnv hook zsh)"
