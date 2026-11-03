# Dotfiles

Configuración personal compartida entre Omarchy (Linux), macOS y Windows.
Cada máquina clona el repo en `~/.dotfiles`; los symlinks son relativos a esa ruta.

## Estructura

| Módulo | Contenido | Plataforma |
|---|---|---|
| `shell/` | `.shared_env`, `.p10k.zsh` e init común de zsh | Todas |
| `git/` | `.gitconfig` base con delta y LFS | Todas |
| `omarchy/` | `.zshrc` y overrides de OpenCode para Omarchy | Linux |
| `mac/` | `.zshrc` específico de macOS | macOS |
| `nvim/` | Configuración completa de Neovim/LazyVim | Todas |
| `opencode/` | Configuración, plugins, skills y TUI de OpenCode | Todas |
| `skills/` | Skills compartidas en `~/.agents/skills` | Todas |
| `bat/`, `delta/`, `lazygit/`, `lazydocker/` | Configs de herramientas | Todas |
| `warp/` | Temas de Warp en `~/.warp/themes` | Todas |
| `whatsapp/` | Helper, MCP, skill y systemd | Solo Linux |
| `windows/` | PowerShell, Terminal, YASB y VSCodium | Windows |
| `scripts/omarchy/` | Instaladores y actualizadores Linux | Linux |
| `profiles/` | Lista de módulos por perfil | — |
| `bootstrap.sh` | Aplica un perfil con stow | — |

## Aplicaciones y CLIs necesarias

| Ámbito | Herramientas |
|---|---|
| Núcleo | `zsh`, `stow`, `git`, `git-lfs`, `git-ftp`, `curl`, `zip`, `unzip`, `7z`, `rg`, `fd` |
| Shell | `bat`, `lsd`, `fzf`, `mise`, `zoxide`, `delta` |
| Editor | `nvim`, `bob` (opcional), `lazygit`, `lazydocker` |
| Node | `node`, `pnpm`, `npx` |
| Agente | `opencode` |
| Python | `python3`, `pip` |
| Skills | `magick`, `php`, `composer`, `usql`, Chrome/Chromium |
| WhatsApp (Linux) | `wacli` |
| PhotoCraft (Omarchy) | `photocraft-cli` dentro del AppImage |
| Opcional | `warp`, `bat-extras` |

Comandos de instalación abajo. El instalador de skills cubre las CLIs Node.

## Instalación

```sh
git clone git@github.com:sprtony/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh omarchy
```

En macOS:

```sh
./bootstrap.sh mac
```

Para reaplicar después de mover archivos:

```sh
./bootstrap.sh omarchy --restow
```

Stow no sobrescribe archivos existentes. Si hay conflicto, mueve o respalda el
archivo real antes de ejecutar el bootstrap. No uses `stow --adopt` sin revisar
el resultado.

## Herramientas

### [Zap](https://github.com/zap-zsh/zap)
```sh
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
```

### [Rust](https://doc.rust-lang.org/book/title-page.html)
```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### [Go](https://go.dev/)
```sh
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go
```

### [Bat](https://github.com/sharkdp/bat)
```sh
cargo install --locked bat
bat cache --build
```

### [Bat-extras](https://github.com/eth-p/bat-extras)
```sh
brew install bat-extras
pacman -S bat-extras
```

### [Lsd](https://github.com/lsd-rs/lsd)
```sh
cargo install lsd
```

### [Bob](https://github.com/MordechaiHadad/bob)
```sh
cargo install bob-nvim
```

### [Delta](https://dandavison.github.io/delta/introduction.html)
```sh
cargo install git-delta
```

### [Lazygit](https://github.com/jesseduffield/lazygit)
```sh
go install github.com/jesseduffield/lazygit@latest
```

### [Lazydocker](https://github.com/jesseduffield/lazydocker)
```sh
go install github.com/jesseduffield/lazydocker@latest
```

## OpenCode

La configuración base vive en `opencode/.config/opencode/`.
Los overrides de Omarchy (MCP de PhotoCraft) se cargan con `OPENCODE_CONFIG`
desde `omarchy/.config/opencode/opencode.omarchy.json`.

Archivos generados que no se versionan: `node_modules/`, `service.json`,
`herdr-opencode/`, `package.json` y `package-lock.json`.

## Neovim

La configuración completa está en `nvim/.config/nvim/`, incluyendo
`lazy-lock.json`. Los plugins se instalan al abrir Neovim.

## Antigravity

Los scripts están en `scripts/omarchy/`. Copiarlos a `/usr/local/bin`:

```sh
sudo cp scripts/omarchy/update-antigravity scripts/omarchy/update-antigravity-ide /usr/local/bin/
```

## [Warp Keybinding (GNOME)](https://www.warp.dev/)
```sh
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/ name 'Warp'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/ command 'warp-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/ binding '<Super>Return'
```

## Dependencias de Skills

### Core
- `opencode` — CLI del agente.
- `python3` + `pip` — scripts de BookStack, Kanboard y skill-creator.
- `node` + `pnpm` — único gestor de paquetes Node global.
- `npx` — find-skills y CLIs temporales.

### Skills específicas

| Skill | CLI / dependencia | Instalación típica |
|---|---|---|
| bookstack-api-skill | `python3`, `requests` | `pip install requests` |
| chrome-devtools | `node`, `chrome-devtools-mcp` | `pnpm add -g chrome-devtools-mcp` |
| context7-skill | `ctx7` | `pnpm add -g ctx7` |
| excel-skill | `excel-cli` | `cargo install excel-cli --locked` |
| find-skills | `npx skills` | incluido con Node |
| git-ftp-deploy | `git`, `git-ftp`, `pnpm` | `sudo apt install git-ftp` + pnpm |
| git-ftp-skill | `git`, `git-ftp` | `sudo apt install git-ftp` |
| imagemagick-conversion | `magick` (ImageMagick) | `sudo apt install imagemagick` |
| kanboard-skill | `python3` | nativo |
| laravel-modular-genius | `php`, `composer`, `artisan` | `sudo apt install php composer` |
| lighthouse | `lighthouse`, Chrome/Chromium | `pnpm add -g lighthouse` |
| magic-skill | `@21st-dev/cli` | `pnpm add -g @21st-dev/cli` |
| playwright-cli | `@playwright/cli` | `pnpm add -g @playwright/cli@latest` |
| skill-creator | `python3` | nativo |
| thinking-skill | `sequential-thinking-cli` | `pnpm add -g sequential-thinking-cli` |
| usql-skill | `usql` | release oficial o `go install` |

Instalador de dependencias en Omarchy:

```sh
./scripts/omarchy/install-missing-skill-deps.sh
./scripts/omarchy/install-missing-skill-deps.sh --remove-npm-globals
```

Instalador de herramientas en macOS:

```sh
./scripts/mac/install-tools.sh
```

## Seguridad

- Los secretos viven fuera del repo: `~/.config/secrets/keys.env` con permisos `600`.
- Nunca versionar `.env`, tokens ni `service.json`.
- Revisar `git status` antes de cada commit.

## WhatsApp desacoplado

Módulo `whatsapp/`: helper standalone sobre `wacli`, sin depender del plugin de
Omarchy. Incluye comando `whatsapp`, MCP `whatsapp-mcp`, skill y unidades
systemd propias. Instalación y actualización en [`whatsapp/README.md`](whatsapp/README.md).
