# path
typeset -U path
path=(~/.rbenv/bin $path)
eval "$(rbenv init -)"

path=(~/.nodebrew/current/bin $path)

path=(~/.cabal/bin $path)

export JAVA_HOME=/etc/alternatives/java_sdk
path=(~/bin/android-studio/bin $path)

export GOPATH=~/.go
export GOROOT=`go env GOROOT`
path=(~/.go/bin $path)

export RSENCE_HOME=~/opt/rsense
