#!/usr/bin/env bash
set -eou pipefail

selection_file="symlink_list.txt"
symlink_dst="$HOME"
force_selection=0
select_all=0

if [ "${1:-}" == "--select" ]; then
    force_selection=1
elif [ "${1:-}" == "--select-all" ]; then
    select_all=1
fi

check_cmd() {
    command -v "$1" >/dev/null 2>&1
    return $?
}

need_cmd() {
    if ! check_cmd "$1"; then
        echo "need '$1' (command not found)" >&2
        exit 1
    fi
}

find_symlink_candidates() {
    fd -H -t f -E .git --strip-cwd-prefix \
        | grep -E '^\.'
}

ask_selection() {
    local preview='cat'
    if check_cmd bat; then
        preview='bat --style=numbers --color=always --line-range=:500'
    fi
    find_symlink_candidates \
        | fzf -m --bind "load:toggle-all" --bind "ctrl-a:toggle-all" \
            --header "(tab to deselect, ctrl-a to toggle all)" \
            --height ~100% --layout reverse --padding 0,0,1,0 \
            --preview "$preview {}"
}

git_exclude_file() {
    local src="$1"
    if ! grep -qFx "$src" ".git/info/exclude"; then
        echo "$src" >> .git/info/exclude
    fi
}

need_cmd fzf
need_cmd fd

if ((select_all)); then
    find_symlink_candidates > "$selection_file"
fi

if [ ! -f "$selection_file" ] || ((force_selection)); then
    selected="$(ask_selection)"
    if [ -z "$selected" ]; then
        # user likely ran ctrl+c
        exit 0
    fi
    echo "$selected" > "$selection_file"
    echo "selection saved to $(realpath "$selection_file")"
fi

while IFS= read -r f; do
    if [ ! -f "$f" ]; then
        echo "can't symlink $f, file doesn't exist" >&2
        continue
    fi
    dst="$symlink_dst/$f"
    mkdir -p -- "$(dirname -- "$dst")"
    ln -sf -- "$(realpath "$f")" "$dst"
    echo "symlinked $f"
done < "$selection_file"

git_exclude_file "$selection_file"
