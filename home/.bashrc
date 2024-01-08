# ============================================================================
# Environment Variables
# ============================================================================

export DOT_HOME=$HOME/dotfiles          # set path to dotfiles

export EDITOR=vim                       # set preferred editor to vim
export VISUAL=vim                       # set preferred visual editor to vim

# ============================================================================
# Functions
# ============================================================================

# function to edit and source .bashrc from anywhere in the filesystem
# "bconf" to open; "bconf so" to source
bconf() {
    if [ $# -eq 1 ]; then
        [ $1 = "so" ] && source "$HOME/.bashrc"
    else
        "${EDITOR:-vi}" "$HOME/.bashrc"
    fi
}

# function to access dotfiles repo from anywhere in the filesystem
# "dot" to cd to dotfiles; "dot [OPTIONS]" to run git commands
# "dot addall" to add all tracked files with changes
dot() {
    if [ $# -eq 0 ]; then
        cd "$DOT_HOME"
    elif [ $# -eq 1 ]; then
        if [ $1 = "addall" ]; then
            git -C "$DOT_HOME" ls-files --modified | xargs git -C "$DOT_HOME" add
        else
            git -C "$DOT_HOME" $1
        fi
    else
        git -C "$DOT_HOME" "$@"
    fi
    return 0
}

# ============================================================================
# More
# ============================================================================

# don't show untracked files in dotfiles repo
git -C $DOT_HOME config --local status.showUntrackedFiles no

# initialize starship prompt if installed
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

