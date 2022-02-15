PS1='\D{%F %T %z} [\u@\h \W]\$ '
export PATH=$HOME/kopt/bin:$HOME/kopt/work/bin:$PATH
export CLICOLOR=1
export EDITOR=vim
export GOPATH=$HOME/sandbox/go-code
export PATH=$PATH:$GOPATH/bin
export HISTSIZE=10000
alias l="ls -l"
alias logcat="adb logcat -v time"
alias ss="adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > ~/Desktop/screen.png"
alias pklist="adb shell pm list packages -f"
alias atext="adb shell input text"
alias pd="pushd"

if [ -f "$HOME/kopt/work/config/bash_additions.inc" ]; then
  source $HOME/kopt/work/config/bash_additions.inc
fi

fix_preamble() {
  FIX_FILE="$1"
  if [ -z "$FIX_FILE" ]
  then
    echo "Please provide filename"
    return 1
  fi
  echo "#!/usr/bin/env bash" >> "$FIX_FILE"
  echo "" >> "$FIX_FILE"
  echo "set -ex" >> "$FIX_FILE"
  chmod u+x "$FIX_FILE"
}

eval "$(direnv hook bash)"

# see https://cgibb.org/bash-history-zen for all the fun details on bash history
HISTFILESIZE=100000
HISTSIZE=$HISTFILESIZE
hsync() {
  history -a
  history -r
}

brules() {
  bazel query 'kind(rule, :*)'
}

allmaketargets () {
  make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'
}

top10commiters() {
  top_committers 10
}

top_committers() {
  git shortlog -s --first-parent | uniq | sort -r | grep -vi bot | head -n "$1"
}

gl() {
  if [ $# -eq 0 ]; then
    git log -n 1
  else
    git log -n $1
  fi
}

scaleimg() {
  convert "$1" -resize "$2" "$2_$1"
}

webgodocs () {
  godoc -http=localhost:6060
}


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

grp() {
  git rev-parse "$1" | pbcopy
}

doreplace() {
  FIND=$1
  REPLACE=$2
  git grep -l "$FIND" | xargs sed -i .bak "$REPLACE"
  clearbak
}

encodeUUID() {
  echo "$1" | xxd -r -p | base64
}

gt () {
  go test -v -race -run "$1"
}

bt () {
  bazel test :all
}

mahlog () {
  git log --author=$(git config user.email) $@
}

if [ -x "$(command -v rustc)" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
  rust_src_lib=$(rustc --print sysroot)/lib/rustlib/src/rust/src
  export RUST_SRC_PATH=$rust_src_lib
fi

clearbak() {
  find . -name "*.bak" -delete
}

if [ "$(uname)" = "Darwin" ] && [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash
fi

if [ "$(uname)" = "Darwin" ] && [ -f `brew --prefix`/etc/bash_completion.d/bazel-complete.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/bazel-complete.bash
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kurtis/google-cloud-sdk/path.bash.inc' ]; then . '/Users/kurtis/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kurtis/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/kurtis/google-cloud-sdk/completion.bash.inc'; fi
