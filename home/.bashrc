config() {
    local repo_dir="$HOME/dotfiles"
    if [ $# -eq 0 ]; then
        cd $repo_dir
    elif [ $# -eq 1 ]; then
        local git_cmd=$1
        git -C "$repo_dir" $git_cmd
    else
        local git_cmd=$1
        shift
        for arg in "$@"; do
            if [ -L "$arg" ]; then
                local resolved_path=$(readlink -f "$arg")
                if [[ "$resolved_path" == "$repo_dir"* ]]; then
                    git -C "$repo_dir" $git_cmd "${resolved_path#$repo_dir/}"
                else
                    echo "The file $arg is not a symlink to a file in the $repo_dir."
                    return 1
                fi
            else
                echo "The file $arg is not a symlink."
                return 1
            fi
        done
    fi
    return 0
}

git -C $HOME/dotfiles config --local status.showUntrackedFiles no

eval "$(starship init bash)"
