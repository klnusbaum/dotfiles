[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
autoload -Uz compinit && compinit
export PATH=$HOME/bin:$HOME/kopt/bin:$HOME/kopt/work/bin:$HOME/google-cloud-sdk/bin:$PATH
export EDITOR=nvim
export GOPATH=$HOME/sandbox/go-code
bindkey -e

if [ -f "$HOME/kopt/work/config/zsh_additions.inc" ]; then
  source $HOME/kopt/work/config/zsh_additions.inc
fi

eval "$(direnv hook zsh)"
