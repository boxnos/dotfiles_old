# path
typeset -U path
path=(~/.rbenv/bin $path)
eval "$(rbenv init -)"

path=(~/.nodebrew/current/bin $path)
