# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH='/home/spider/.oh-my-bash'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="purity"

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

source "$OSH"/oh-my-bash.sh

# You may need to manually set your language environment
export LANG=pl_PL.UTF-8

# My additions
#
# Vi style line editing
set -o vi
#
# JAVA_HOME
export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
# PATH
export PATH=$PATH:"/home/spider/.dotnet:/home/spider/.dotnet/tools:/usr/local/bin:/usr/local/go/bin:/home/spider/work/bin:/home/spider/skrypty"
# Required for dotnet to work
export DOTNET_ROOT=/home/spider/.dotnet
# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
# Aliases
alias c=clear
alias bat=batcat
alias ls='eza --colour=always --icons=always --group-directories-first'
alias ll='eza -l --colour=always --icons=always --git --group-directories-first --no-permissions'
alias cd='z'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias py='python3'
alias cat='bat'

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

. "$HOME/.atuin/bin/env"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

. "$HOME/.cargo/env"

# Zoxide
eval "$(zoxide init bash)"

# bat theme
export BAT_THEME="Enki-Tokyo-Night"

# polish keyboard
#setxkbmap pl

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
#(cat ~/.cache/wal/sequences &)

# To add support for TTYs this line can be optionally added.
#source ~/.cache/wal/colors-tty.sh
