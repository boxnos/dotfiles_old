PLUGINS=~/.zsh/plugins

autoload -U compinit
fpath=(~/.zsh/completions $fpath)
fpath=($PLUGINS/zsh-completions/src $fpath)
compinit

# predict
# source ~/.zsh/predict.config.zsh
# source ~/.zsh/auto-fu.config.zsh

HISTFILE=$HOME/.zsh/.zsh-history
HISTSIZE=100000                       # on memory
SAVEHIST=100000                       # file
setopt extended_history               # add time stamps
setopt share_history
function history-all { history -E 1 }

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# cd
setopt auto_pushd

# z
export _Z_DATA=~/.cache/.z
source $PLUGINS/z/z.sh

# zaw
source $PLUGINS/zaw/zaw.zsh

# prompt
PROMPT="%% "
RPROMPT="[%~]"

# edit with $EDITOR
export EDITOR=vim
autoload edit-command-line
zle -N edit-command-line
# M-e
bindkey "\ee" edit-command-line

# vim
foreground() {
  if [[ -n $(jobs) ]]; then
    echo
    fg
    zle reset-prompt
  fi
}
zle -N foreground
bindkey '^Z' foreground

# zstyle
zstyle ':completion:*:sudo:*' command-path
# zstyle ':completion:*:bundle exec:*' command-path ~/.rbenv/shims

# ignore all
ig() { "$@" &> /dev/null }
_ig() { _arguments ':command:_command_names -e' '*::args:_normal' }
compdef _ig ig

# hashes
hash -d gemdir=$(gem environment gemdir)
# private hashes
source ~/.zsh/hashes.zsh
