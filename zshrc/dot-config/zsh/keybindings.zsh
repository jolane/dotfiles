bindkey -v

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end
bindkey "${terminfo[kcuu1]}" history-beginning-search-backward-end
bindkey "${terminfo[kcud1]}" history-beginning-search-forward-end

bindkey '^R' history-incremental-search-backward
bindkey '^@' expand-or-complete

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
