PROMPT='%D{%F %T %Z} %1d # '

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory

autoload -Uz compinit && compinit
export PATH=$HOME/bin:$HOME/kopt/bin:$HOME/kopt/work/bin:$HOME/google-cloud-sdk/bin:$PATH
export EDITOR=nvim
export GOPATH=$HOME/sandbox/go-code
export PATH=$PATH:$GOPATH/bin
bindkey -e

if [ -f "$HOME/kopt/work/config/zsh_additions.inc" ]; then
  source $HOME/kopt/work/config/zsh_additions.inc
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(direnv hook zsh)"
