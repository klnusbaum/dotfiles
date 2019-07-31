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
alias adm="arc diff -m"
alias ad="arc diff HEAD^"
alias pd="pushd"
alias vim="nvim"

land () { 
  if [ "$#" -eq 0 ]; then
    arc land 
  elif [ $# -eq 1 ]; then
    echo "Landing and rebasing"
    arc land --keep-branch "$1" && git checkout master && git merge && git checkout - && git rebase master
  elif [ "$1" == "-nr" ]; then
    arc land --keep-branch "$2"
  else
    echo "Argument error"
  fi  
}

encodeUUID() {
  echo "$1" | xxd -r -p | base64
}

gt () {
  go test -v -race -run "$1"
}

bt () {
  bazel test --test_arg=-test.v --test_output=all ...
}

bb () {
  bazel build ...
}

mahlog () {
  git log --author=$(git config user.email)
}

export PATH="$HOME/.cargo/bin:$PATH"
rust_src_lib=$(rustc --print sysroot)/lib/rustlib/src/rust/src
export RUST_SRC_PATH=$rust_src_lib

clearbak() {
  find . -name "*bak" -exec rm {} \;
}

if [ "$(uname)" = "Darwin" ] && [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash
fi

if [ "$(uname)" = "Darwin" ] && [ -f `brew --prefix`/etc/bash_completion.d/bazel-complete.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/bazel-complete.bash
fi
