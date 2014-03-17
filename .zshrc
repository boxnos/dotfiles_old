autoload -U compinit
fpath=(~/.zsh/zsh-completions/src $fpath)
compinit

# predict
# source ~/.zsh/predict.config.zsh
# source ~/.zsh/auto-fu.config.zsh

HISTFILE=$HOME/.zsh/.zsh-history           # 履歴をファイルに保存する
HISTSIZE=100000                       # メモリ内の履歴の数
SAVEHIST=100000                       # 保存される履歴の数
setopt extended_history               # 履歴ファイルに時刻を記録
function history-all { history -E 1 } # 全履歴の一覧を出力する

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# cd
setopt auto_pushd

PROMPT="%% "
RPROMPT="[%~]"

# edit with $EDITOR
export EDITOR=vim
autoload edit-command-line
zle -N edit-command-line
# M-e
bindkey "\ee" edit-command-line

# path
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# http://blog.geta6.net/post/60605922314/zstyle-command-path-path改
function zstyle-command-path() {
  typeset -a not_sbin_path
  for it in $path; do
    [[ sbin != ${it##*/} ]] && not_sbin_path=($not_sbin_path $it)
  done

  case ${UID} in
    0)
      zstyle ':completion:*' command-path $path
      ;;
    *)
      zstyle ':completion:*' command-path $not_sbin_path
      zstyle ':completion:*:sudo:*' command-path $path
      ;;
  esac
}
zstyle-command-path
hash -d dot-install=~/work/study/dot-install
