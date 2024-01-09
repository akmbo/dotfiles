# ============================================================================
# Environment Variables
# ============================================================================

BASHRC_DIR="$(dirname $(realpath $BASH_SOURCE))"

DOT_HOME="$(git -C "$BASHRC_DIR" rev-parse --show-toplevel)"
DOT_INSTALL_DIR="$HOME/.local"

XDG_CONFIG_HOME="$HOME/.config"

EDITOR=vim                       # set preferred editor to vim
VISUAL=vim                       # set preferred visual editor to vim

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

vconf() {
    if [ $# -eq 1 ]; then
        [ $1 = "so" ] && source "$HOME/.vim/vimrc"
    else
        "${EDITOR:-vi}" "$HOME/.vim/vimrc"
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
# Load programs
# ============================================================================

# load nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# initialize starship prompt if installed
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# ============================================================================
# More
# ============================================================================

# don't show untracked files in dotfiles repo
git -C $DOT_HOME config --local status.showUntrackedFiles no

