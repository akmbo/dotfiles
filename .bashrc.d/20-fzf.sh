_preview='cat'
if command -v bat >/dev/null 2>&1; then
    _preview='bat -n --color=always --line-range=:1000 2>/dev/null'
fi

_fzf_skip=(
    .git
    node_modules
    target
    .venv
    __pycache__
    .mypy_cache
    .ruff_cache
    .pytest_cache
    .DS_Store
)
_fzf_skip_str=$(IFS=,; echo "${_fzf_skip[*]}")

export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --hidden --walker-skip $_fzf_skip_str"
export FZF_CTRL_T_OPTS="
    --walker-skip $_fzf_skip_str
    --preview '$_preview {}'
    --height 60%
    --bind 'ctrl-/:change-preview-window(hidden|)'"

eval "$(fzf --bash 2>/dev/null)"

unset _preview _fzf_skip _fzf_skip_str
