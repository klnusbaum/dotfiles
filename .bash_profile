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
  elif [ "$1" == "land" ] && [ "$#" -eq 1 ]; then
    arc land --keep-branch "$1" && git checkout master && git merge && git checkout - && git rebase master
  elif [ "$1" == "land" ] && [ "$2" == "-nr" ]; then
    arc land --key-branch "$1"
  fi  
}

encodeUUID() {
  echo "$1" | xxd -r -p | base64
}

tcopy () {
  tmux showb | pbcopy
}

gt () {
		go test -v -race -run "$1"
}

rust_src_lib=$(rustc --print sysroot)/lib/rustlib/src/rust/src
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH=$rust_src_lib
