# source profile.d
for f in "$HOME/.profile.d/"*.sh; do
    [[ -r $f ]] && . "$f"
done

# source bashrc for interactive bash
[[ -n $BASH_VERSION && -f ~/.bashrc ]] && . ~/.bashrc
