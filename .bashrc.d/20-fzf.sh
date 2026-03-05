__preview='cat'
if command -v bat >/dev/null 2>&1; then
    __preview='bat -n --color=always --line-range=:1000 2>/dev/null'
fi

export FZF_DEFAULT_COMMAND='fd --strip-cwd-prefix --hidden --exclude .git'
export FZF_CTRL_T_OPTS="
    --walker-skip .git,node_modules,target
    --preview '$__preview {}'
    --height ~60%
    --bind 'ctrl-/:change-preview-window(hidden|)'"

eval "$(fzf --bash 2>/dev/null)"
