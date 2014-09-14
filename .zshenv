# path
typeset -U path
path=(~/.rbenv/bin $path)
eval "$(rbenv init -)"

path=(~/.nodebrew/current/bin $path)

path=(~/.cabal/bin $path)

export GOPATH=~/go
path=(~/.cabal/bin $path)

export RSENCE_HOME=~/opt/rsense
