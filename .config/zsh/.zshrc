source "$ZDOTDIR/aliases.zsh"

case "$OSTYPE" in
    linux*)
        source "$ZDOTDIR/linux.zsh"
        ;;
    darwin*)
        source "$ZDOTDIR/macos.zsh"
        ;;
esac

source "$ZDOTDIR/tools.zsh"
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/functions.zsh"
