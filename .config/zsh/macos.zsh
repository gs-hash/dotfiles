# default programs
export EDITOR="nvim"
export BROWSER="firefox"

# JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home)
# dotnet
export DOTNET_ROOT=/usr/local/share/dotnet
# PATH
typeset -U path PATH
path+=(
	"$HOME/.atuin/bin"
	"$HOME/.dotnet/tools"
	"/opt/homebrew/bin"
)
# Aliases
alias schowek='pbcopy'

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'
