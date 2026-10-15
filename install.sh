#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PACKAGES=(
    tmux
    nvim
    starship
    kitty
    atuin
    wezterm
    zellij
    zsh
)

stow --dir="$SCRIPT_DIR" --target="$HOME" "$@" --restow "${PACKAGES[@]}"
