# path
typeset -U path
path=(~/.rbenv/bin $path)
# export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
