# interactive guard
case $- in
    *i*) ;;
    *) return;;
esac

# source bashrc.d
for f in "$HOME/.bashrc.d/"*.sh; do
    [[ -r $f ]] && . "$f"
done
