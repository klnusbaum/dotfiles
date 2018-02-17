source ~/.git-completion.bash

export CLICOLOR=1
export EDITOR=vim
export GOPATH=$HOME/sandbox/gocode
alias l="ls -l"
alias whatsnew="git diff HEAD^ --name-only"
alias logcat="adb logcat -v time"
alias ss="adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > ~/Desktop/screen.png"
alias pklist="adb shell pm list packages -f"
alias atext="adb shell input text"
alias ado="arc diff --only"
alias ad="arc diff HEAD^"
alias pd="pushd"
alias vim="nvim"

land () { 
  if [ "$#" -eq 0 ]; then
    echo "Landing and rebasing"
    arc land 
  else
    arc land --keep-branch $1 && git checkout master && git merge && git checkout - && git rebase master
  fi  
}

encodeUUID() {
  echo "$1" | xxd -r -p | base64
}

tcopy () {
  tmux showb | pbcopy
}

gt () {
		go test -v -race -run $1
}

export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src
