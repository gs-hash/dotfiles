# default programs
export EDITOR="nvim"
export BROWSER="firefox"

# history files
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"

# JAVA_HOME
export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")

# dotnet
export DOTNET_ROOT=/usr/share/dotnet
# PATH
typeset -U path PATH
path+=(
  "/usr/local"
  "/usr/local/bin"
  "/usr/local/go/bin"
  "$HOME/work/bin"
  "$HOME/skrypty"
  "$HOME/.atuin/bin"
  "$HOME/.dotnet/tools"
  "$HOME/.cargo/bin"
  "$HOME/.local/bin"
  "/home/linuxbrew/.linuxbrew/bin"
)
# Aliases
alias bat='batcat'
alias getidf='source ~/programowanie/esp/esp-idf/export.sh'
alias schowek='xclip -selection clipboard'

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

