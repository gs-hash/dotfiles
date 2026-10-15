# dotfiles

Konfiguracje zarządzane przez GNU Stow. Każdy pakiet odtwarza ścieżki względem
`$HOME`. `install.sh` podłącza: `kitty`, `tmux`, `nvim`, `starship`, `atuin`,
`wezterm`, `zellij` i `zsh`. Nie instaluje programów.

## Instalacja narzędzi — Debian 13

Polecenia wykonuj w Bash. Podstawowe pakiety systemowe:

```bash
sudo apt update
sudo apt install -y git stow zsh kitty tmux bat python3 curl wget unzip \
    xz-utils build-essential pkg-config fontconfig xclip wl-clipboard \
    xdg-utils firefox openjdk-21-jdk libxml2-utils shellcheck
```

`bat` w Debianie udostępnia `batcat`, którego używa alias w `linux.zsh`.
`xclip` obsługuje alias `schowek` w X11; w sesji Wayland zmień go na `wl-copy`.
JDK zapewnia również `/usr/bin/javac`, z którego konfiguracja wylicza `JAVA_HOME`.

Aktualne narzędzia CLI instalujemy przez [Homebrew na Linuxie](https://docs.brew.sh/Homebrew-on-Linux).
Konfiguracja zawiera już ścieżkę `/home/linuxbrew/.linuxbrew/bin`.
Jeżeli Homebrew nie jest zainstalowany:

```bash
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
    -o /tmp/dotfiles-homebrew-install.sh
bash /tmp/dotfiles-homebrew-install.sh
```

Następnie, również gdy Homebrew był już zainstalowany:

```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install neovim fzf zoxide eza atuin starship zellij ripgrep fd \
    tree-sitter-cli stylua shfmt node
```

Używaj Neovima z Homebrew (konfiguracja korzysta z `vim.lsp.config` i
`vim.lsp.enable`, dostępnych od 0.11). Aktualne wersje wtyczek mogą wymagać
nowszego Neovima, np. [roslyn.nvim wymaga 0.12](https://github.com/seblyng/roslyn.nvim#%EF%B8%8F-requirements).
`fzf` musi obsługiwać `fzf --zsh` (od 0.48).

| Narzędzia                                                             | Gdzie są używane                                          |
| --------------------------------------------------------------------- | --------------------------------------------------------- |
| `zsh`, `git`                                                          | Powłoka, automatyczne pobieranie Zinit i wtyczek          |
| `fzf`, `zoxide`, `atuin`, `starship`                                  | Bezwarunkowa inicjalizacja w `tools.zsh`                  |
| `eza`, `batcat`, `python3`, `nvim`                                    | Aliasy `ls`/`ll`/`la`, `cat`, `py`, `v`/`vi`/`vim`        |
| `kitty`, `tmux`, `zellij`                                             | Terminal i multipleksery z konfiguracją w repozytorium    |
| `ripgrep`, `fd`, `make`, kompilator C                                 | Wyszukiwanie Telescope i budowanie `telescope-fzf-native` |
| `tree-sitter` (pakiet `tree-sitter-cli`), `curl`, `tar`, kompilator C | Instalacja parserów nvim-treesitter                       |
| `stylua`, `shfmt`, `shellcheck`, `xmllint` (pakiet `libxml2-utils`)   | Formatowanie Lua/shell/XML i lintowanie shell             |
| `node`, `npm`                                                         | Instalacja narzędzi webowych poniżej                      |
| `xdg-open`, Firefox                                                   | Otwieranie odnośników, m.in. z obsidian.nvim              |

WezTerm jest alternatywnym terminalem. Jeśli go używasz, zainstaluj go z
[oficjalnego tapu dla Linuxa](https://wezterm.org/install/linux.html#linuxbrew-tap):

```bash
brew tap wezterm/wezterm-linuxbrew
brew install wezterm/wezterm-linuxbrew/wezterm
```

## Fonty

Kitty używa **FiraCode Nerd Font**, a WezTerm wskazuje **HackNerdFont**.
Zainstaluj FiraCode i Hack z [Nerd Fonts](https://www.nerdfonts.com/font-downloads),
aby działały także ikony eza, Neovima i znaki Powerline w tmux/Starship.
Zwykłe Fira Code/Hack bez rozszerzenia Nerd Fonts nie zapewniają wszystkich ikon.

```bash
font_download_dir=$(mktemp -d)
for font in FiraCode Hack; do
    mkdir -p "$HOME/.local/share/fonts/$font"
    curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip" \
        -o "$font_download_dir/$font.zip"
    unzip -o "$font_download_dir/$font.zip" -d "$HOME/.local/share/fonts/$font"
done
fc-cache -f
fc-match 'FiraCode Nerd Font'
fc-match 'Hack Nerd Font'
```

Po instalacji uruchom terminal ponownie. `fc-match` potrafi zwrócić font zastępczy,
więc sprawdź nazwę rodziny w wyniku. Jeśli WezTerm nie rozpoznaje `HackNerdFont`,
ustaw w `.wezterm.lua` nazwę rodziny `Hack Nerd Font` zgodną z zainstalowanym fontem.

## Neovim — narzędzia zależne od języka

Lazy instaluje wtyczki Neovima, ale nie zewnętrzne serwery LSP, formatery ani
SDK. Brak narzędzia oznacza brak odpowiedniej funkcji; część serwerów LSP jest
włączana dopiero po znalezieniu programu w `PATH`.

### Lua, Bash, HTML i formatowanie webowe

```bash
brew install lua-language-server
npm install --global bash-language-server vscode-langservers-extracted prettier
```

`vscode-langservers-extracted` dostarcza `vscode-html-language-server`.
Prettier obsługuje Markdown, HTML, CSS/SCSS, JS/TS, JSON i YAML.
Przy Node z Homebrew nie używaj `sudo npm`.

### Java

```bash
brew install jdtls google-java-format
```

`jdtls` dostarcza serwer LSP; Homebrew instaluje również wymagany przez niego JDK.
Systemowy JDK z pierwszego kroku służy projektom i ustawieniu `JAVA_HOME`.
Maven/Gradle są zależne od projektu — preferuj jego `./mvnw` lub `./gradlew`.
Jeśli projekt nie ma wrappera: `brew install maven gradle`.

Debugowanie Java wymaga dodatkowo zbudowanego
[java-debug](https://github.com/microsoft/java-debug):

```bash
brew install maven
mkdir -p "$HOME/.local/share/java"
git clone https://github.com/microsoft/java-debug.git "$HOME/.local/share/java/java-debug"
(cd "$HOME/.local/share/java/java-debug" && mvn clean install)
```

Konfiguracja szuka jego plików JAR w
`~/.local/share/java/java-debug/com.microsoft.java.debug.plugin/target/`.
Opcjonalne testy Java wymagają również JAR-ów
[vscode-java-test](https://github.com/microsoft/vscode-java-test) w
`~/.local/share/java/vscode-java-test/server/`.
Konfiguracja „Attach Spring Boot” oczekuje aplikacji z włączonym JDWP na porcie 5005.

### C# / Razor

Zainstaluj .NET SDK z [repozytorium Microsoft dla Debiana 13](https://learn.microsoft.com/en-us/dotnet/core/install/linux-debian):

```bash
curl -fL https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb \
    -o /tmp/dotfiles-packages-microsoft-prod.deb
sudo dpkg -i /tmp/dotfiles-packages-microsoft-prod.deb
sudo apt update
sudo apt install -y dotnet-sdk-10.0
export DOTNET_ROOT=/usr/share/dotnet
export PATH="$HOME/.dotnet/tools:$PATH"
dotnet tool install --global csharpier
dotnet tool install --global roslyn-language-server --prerelease \
    --source https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json
```

To odpowiada `DOTNET_ROOT` w `linux.zsh`. Doinstaluj SDK/runtime wymagany przez
`global.json` i projekty. Serwer instaluje się zgodnie z
[instrukcją roslyn.nvim](https://github.com/seblyng/roslyn.nvim#-installation).
Dla już zainstalowanych narzędzi użyj `dotnet tool update --global ...`.
`csharp-ls` (`dotnet tool install --global csharp-ls`) jest alternatywą w
`lsp.lua`, ale nie zastępuje Roslyna w konfiguracji Razor.

Do debugowania pobierz archiwum dla swojej architektury z
[wydań netcoredbg](https://github.com/Samsung/netcoredbg/releases), a następnie
rozpakuj katalog `netcoredbg` do `~/.local/share/`, np. dla Linux amd64:

```bash
mkdir -p "$HOME/.local/share"
tar -xzf "$HOME/Pobrane/netcoredbg-linux-amd64.tar.gz" -C "$HOME/.local/share"
test -x "$HOME/.local/share/netcoredbg/netcoredbg"
```

### Rust

```bash
curl -fsSL https://sh.rustup.rs -o /tmp/dotfiles-rustup.sh
sh /tmp/dotfiles-rustup.sh -y
. "$HOME/.cargo/env"
rustup component add rust-analyzer clippy rustfmt
```

LSP korzysta z `rust-analyzer`, Cargo i Clippy. Debugowanie wymaga CodeLLDB.
Pobierz pasujący plik VSIX z [wydań CodeLLDB](https://github.com/vadimcn/codelldb/releases)
i rozpakuj go (przykład dla x86_64):

```bash
mkdir -p "$HOME/.local/share/codelldb"
unzip "$HOME/Pobrane/codelldb-linux-x64.vsix" -d "$HOME/.local/share/codelldb"
chmod +x "$HOME/.local/share/codelldb/extension/adapter/codelldb"
```

`dap.lua` znajduje debugery w powyższych katalogach lub w `PATH`.

### LaTeX

```bash
sudo apt install -y latexmk texlive-luatex texlive-latex-extra \
    texlive-fonts-recommended texlive-lang-polish zathura zathura-pdf-poppler
brew install texlab
```

VimTeX używa `latexmk -lualatex` i Zathury, a LSP — `texlab`.
Dodatkowe pakiety TeX/fonty zależą od dokumentu. Na macOS odpowiednikiem
przeglądarki w tej konfiguracji jest Skim.

## Podłączenie konfiguracji przez Stow

```bash
git clone https://github.com/gs-hash/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
./install.sh --simulate
./install.sh
mkdir -p "$HOME/.cache" "$HOME/.local/share/python"
chsh -s /usr/bin/zsh
```

Jeśli repozytorium już istnieje, pomiń klonowanie. Skrypt jawnie ustawia cel na
`$HOME`, więc repozytorium może znajdować się także w innym katalogu.
Po `chsh` wyloguj się i zaloguj ponownie. Zinit i jego wtyczki pobiorą się przy
pierwszym uruchomieniu Zsh; wtyczki Neovima przy pierwszym uruchomieniu `nvim`.
Te kroki wymagają dostępu do Internetu.

Stow zgłosi konflikt, jeżeli docelowy plik już istnieje i nie jest jego
symlinkiem. Najpierw porównaj zawartość i przenieś kolidujący plik do kopii
zapasowej, a potem ponów instalację. Nie używaj `--adopt` bez porównania —
przenosi istniejące pliki do repozytorium.

Sam pakiet kitty można podłączyć poleceniem:

```bash
stow --dir="$HOME/dotfiles" --target="$HOME" --restow kitty
```

W repozytorium kitty zapisane są aktywne ustawienia i dołączany motyw
`tokyonight-moon.conf`. Kopie `.bak` i nieaktywny `current-theme.conf` nie są
potrzebne. Pozostałe opcje korzystają z domyślnych wartości kitty.

### Wtyczki tmux i uwagi do istniejących konfiguracji

Aktualny `tmux.conf` uruchamia TPM z `~/.tmux/plugins/tpm/tpm`:

```bash
mkdir -p "$HOME/.tmux/plugins"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
```

Uruchom tmux i naciśnij `Ctrl-a`, następnie `Shift-i`, aby zainstalować wtyczki.
Katalogi wtyczek zapisane pod `tmux/.config/tmux/plugins` są gitlinkami bez
`.gitmodules`; świeży klon nie pobierze ich automatycznie.
Skrót przeładowania `Ctrl-a r` wskazuje `~/.tmux.conf`; przy obecnym układzie
użyj `tmux source-file ~/.config/tmux/tmux.conf`.

`SUDO_EDITOR` wskazuje Neovima w `/home/linuxbrew/.linuxbrew/bin/nvim`.
Alias `getidf` wymaga osobnej instalacji ESP-IDF w `~/programowanie/esp/esp-idf`.
Ścieżki Go, własnych skryptów i OpenCode w `PATH` nie wymagają instalowania tych
narzędzi do uruchomienia powłoki. Obsidian.nvim włącza się tylko, gdy istnieje
`~/Dokumenty/ObsidianVault` lub katalog wskazany przez `OBSIDIAN_VAULT`.
Pliki `.zshrc_old`, `.zshrc_small` i `config.kdl.bak` nie są aktywną konfiguracją.

## Sprawdzenie

```bash
./install.sh --simulate
bash -n install.sh
shellcheck install.sh
shfmt -d -i 4 install.sh
nvim --headless '+qa'
```

W Neovimie sprawdź też `:checkhealth` i `:ConformInfo`.
ShellCheck nie obsługuje składni Zsh, mimo przypisania go do `zsh` w `lint.lua`.
