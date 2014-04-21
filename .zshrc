autoload -U compinit
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)
fpath=(~/.zsh/completions $fpath)
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

export _Z_DATA=~/.cache/.z
source ~/.zsh/plugins/z/z.sh

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
  echo
  fg
  zle reset-prompt
}
zle -N foreground
bindkey '^Z' foreground

# zstyle
zstyle ':completion:*:sudo:*' command-path $path
zstyle ':completion:*:bundle exec:*' command-path $path

# hashes
source ~/.zsh/hashes.zsh
