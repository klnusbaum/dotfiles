PS1='\D{%F %T %z} [\u@\h \W]\$ '
export PATH=$HOME/bin:$PATH
export CLICOLOR=1
export EDITOR=nvim
export GOPATH=$HOME/sandbox/go-code
export PATH=$PATH:$GOPATH/bin
export HISTSIZE=10000
alias l="ls -l"
alias whatsnew="git diff HEAD^ --name-only"
alias logcat="adb logcat -v time"
alias ss="adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > ~/Desktop/screen.png"
alias pklist="adb shell pm list packages -f"
alias atext="adb shell input text"
alias pd="pushd"
alias gg="git grep"

eval "$(direnv hook bash)"

# see https://cgibb.org/bash-history-zen for all the fun details on bash history
HISTFILESIZE=100000
HISTSIZE=$HISTFILESIZE

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
  git shortlog -s --first-parent | uniq | sort -r | head -n "$1"
}

uuid()
{
    local N B T

    for (( N=0; N < 16; ++N ))
    do
        B=$(( $RANDOM%255 ))

        if (( N == 6 ))
        then
            printf '4%x' $(( B%15 ))
        elif (( N == 8 ))
        then
            local C='89ab'
            printf '%c%x' ${C:$(( $RANDOM%${#C} )):1} $(( B%15 ))
        else
            printf '%02x' $B
        fi

        for T in 3 5 7 9
        do
            if (( T == N ))
            then
                printf '-'
                break
            fi
        done
    done

    echo
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
  git grep -l "$FIND" | xargs sed -i .bak $REPLACE
  clearbak
}

encodeUUID() {
  echo "$1" | xxd -r -p | base64
}

gt () {
  go test -v -race -run "$1"
}

bt () {
  bazel test ...
}

mahlog () {
  git log --author=$(git config user.email) $@
}

export PATH="$HOME/.cargo/bin:$PATH"
rust_src_lib=$(rustc --print sysroot)/lib/rustlib/src/rust/src
export RUST_SRC_PATH=$rust_src_lib

clearbak() {
  find . -name "*.bak" -delete
}

if [ "$(uname)" = "Darwin" ] && [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash
fi

if [ "$(uname)" = "Darwin" ] && [ -f `brew --prefix`/etc/bash_completion.d/bazel-complete.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/bazel-complete.bash
fi
