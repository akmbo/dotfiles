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
        [ $1 = "so" ] && source $HOME/.bashrc
    else
        "${EDITOR:-vi}" $HOME/.bashrc
    fi
}

# function to access dotfiles repo from anywhere in the filesystem
# "config" to cd to dotfiles; "config [OPTIONS]" to run git commands
config() {
    [ $# -eq 0 ] && cd $DOT_HOME
    local git_cmd=$1
    if [ $# -eq 1 ]; then
        git -C "$DOT_HOME" $git_cmd
        continue
    fi
    shift
    for arg in "$@"; do
        if [ -L "$arg" ]; then
            local resolved_path=$(readlink -f "$arg")
            if [[ "$resolved_path" == "$DOT_HOME"* ]]; then
                git -C "$DOT_HOME" $git_cmd "${resolved_path#$DOT_HOME/}"
            else
                echo "The file $arg is not a symlink to a file in the $DOT_HOME."
                return 1
            fi
        else
            echo "The file $arg is not a symlink."
            return 1
        fi
    done
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

