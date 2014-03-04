autoload predict-on
zle-line-init() { predict-on }
zle -N zle-line-init
zle -N predict-on
zle -N predict-off
zstyle ':predict' verbose false
zstyle ':predict' toggle true
