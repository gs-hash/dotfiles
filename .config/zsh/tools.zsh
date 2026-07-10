if command -v brew >/dev/null; then
    eval "$(brew shellenv)"
fi
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"

