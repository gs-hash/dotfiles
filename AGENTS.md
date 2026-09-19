# Repository Guidelines

## Project Structure & Module Organization

This repository manages user configuration with GNU Stow. Each top-level package mirrors paths relative to `$HOME`:

- `nvim/.config/nvim/` contains Neovim configuration. Plugin specifications live in `lua/plugins/`, while shared behavior lives in `lua/spider/`.
- `zsh/.config/zsh/` contains modular shell configuration such as `aliases.zsh`, `functions.zsh`, and OS-specific files.
- `tmux/`, `starship/`, `alacritty/`, `zellij/`, and `wezterm/` contain application-specific configuration.
- `install.sh` defines the packages installed by Stow.
- `.github/workflows/ci.yml` defines repository-wide shell checks.

Add new files beneath the package that owns their final home-directory path. For example, `foo/.config/foo/config.toml` becomes `~/.config/foo/config.toml`.

## Build, Test, and Development Commands

There is no build step. Use these checks before submitting changes:

```bash
./install.sh
stow -n -R nvim
find . -name '*.sh' -exec shellcheck {} +
find . -name '*.sh' -exec shfmt -d {} +
stylua --check nvim/.config/nvim
nvim --headless '+qa'
```

`./install.sh` restows all configured packages and changes symlinks in `$HOME`; use the dry-run command first when testing layout changes. The two shell commands match CI. StyLua and the headless Neovim startup check cover Lua formatting and configuration errors.

## Coding Style & Naming Conventions

Follow `.editorconfig`: UTF-8, LF endings, final newlines, four-space indentation, and no trailing whitespace. Neovim Lua follows `.stylua.toml`, which uses two spaces, single quotes where possible, and a 100-column limit. Keep plugin specifications focused and name them after the plugin or responsibility, such as `lua/plugins/roslyn.lua`. Shell scripts must use safe quoting and pass both `shellcheck` and `shfmt`.

## Testing Guidelines

No automated unit-test suite is present. Validate the smallest affected surface: start Neovim after Lua changes, source shell files in a clean shell, and use the application's own validation command when available. Confirm `stow -n -R <package>` reports only intended links.

## Commit & Pull Request Guidelines

History favors short, task-focused subjects such as `Added Roslyn` and `fixed tmux on linux`. Use a concise imperative subject, preferably naming the affected tool. Keep unrelated configuration changes in separate commits. Pull requests should explain the motivation, list affected packages, report commands run, and call out OS-specific behavior. Include screenshots only for visible terminal or editor changes.

## Security & Configuration Tips

Do not commit secrets, tokens, machine-specific caches, shell history, or generated state. Review staged diffs carefully because dotfiles can expose local paths and account details.
