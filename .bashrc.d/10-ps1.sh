__prompt_git() {
    local s=''
    local branchName=''

    # check if the current directory is in a git repository
    git rev-parse --is-inside-work-tree &>/dev/null || return

    # Check for what branch we're on.
    # Get the short symbolic ref. If HEAD isn't a symbolic ref, get a
    # tracking remote branch or tag. Otherwise, get the
    # short SHA for the latest commit, or give up.
    branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
        git describe --all --exact-match HEAD 2> /dev/null || \
        git rev-parse --short HEAD 2> /dev/null || \
        echo '(unknown)')"

    [ -n "$s" ] && s=" [$s]"

    echo -e "${1}${branchName}${s}${2}"
}

__get_ps1() {
    local white="\e[0m"
    local red="\e[01;31m"
    local green="\e[01;32m"
    local blue="\e[01;34m"
    local userpart="\[$green\]\u@\H"
    local workingdir="\[$blue\]\w\[$white\]"
    local gitbranch="\$(__prompt_git \"\[$white\](\[$red\]\" \"\[$white\])\")"
    # echo "$userpart \[$white\]→ ${workingdir}${gitbranch} \[$white\]\$ "
    echo "$userpart\[$white\]:${workingdir}${gitbranch}\[$white\]\$ "
}

export PS1="$(__get_ps1)"
