export FZF_DEFAULT_COMMAND='fd . --hidden --exclude ".git"'
eval "$(fzf --bash 2>/dev/null)"
