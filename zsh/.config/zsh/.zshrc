source "$XDG_CONFIG_HOME/zsh/aliases.zsh"

case "$OSTYPE" in
    linux*)
        source "$XDG_CONFIG_HOME/zsh/linux.zsh"
        ;;
    darwin*)
        source "$XDG_CONFIG_HOME/zsh/macos.zsh"
        ;;
esac

source "$XDG_CONFIG_HOME/zsh/tools.zsh"
source "$XDG_CONFIG_HOME/zsh/plugins.zsh"
source "$XDG_CONFIG_HOME/zsh/functions.zsh"
