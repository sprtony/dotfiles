# Requisitos
- zsh
- stow
- git-ftp
- zip
- unzip
- 7zip
- rip-grep
- fd-find

# [Zap](https://github.com/zap-zsh/zap)
```sh
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
```

# [Rust](https://doc.rust-lang.org/book/title-page.html)
```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

# [Go](https://go.dev/)
```sh
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go
```

# [Bat](https://github.com/sharkdp/bat)
```sh
cargo install --locked bat
bat cache --build
```

# [Bat-extras](https://github.com/eth-p/bat-extras)
```sh
brew install bat-extras
pacman -S bat-extras
```

# [Lsd](https://github.com/lsd-rs/lsd)
```sh
cargo install lsd
```

# [Bob](https://github.com/MordechaiHadad/bob)
```sh
cargo install bob-nvim
```

# [Delta](https://dandavison.github.io/delta/introduction.html)
```sh
cargo install git-delta
```

# [Lazygit](https://github.com/jesseduffield/lazygit)
```sh
go install github.com/jesseduffield/lazygit@latest
```

# [Lazydocker](https://github.com/jesseduffield/lazydocker)
```sh
go install github.com/jesseduffield/lazydocker@latest
```

# Install Antigravity
copiar los scripts en /usr/local/bin


# [Warp Keybinding (GNOME)](https://www.warp.dev/)
```sh
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/ name 'Warp'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/ command 'warp-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/ binding '<Super>Return'
```

# Dependencias de Skills

## Core
- `opencode` — CLI del agente (instalar según instrucciones oficiales).
- `python3` + `pip` — scripts de bookstack, kanboard, skill-creator.
- `node` + `pnpm` — CLIs basadas en Node; instalar paquetes globales con pnpm.
- `npx` — find-skills y CLIs temporales.

## Skills específicas

| Skill | CLI / dependencia | Instalación típica |
|---|---|---|
| bookstack-api-skill | `python3`, `requests` | `pip install requests` |
| chrome-devtools | `node`, `chrome-devtools-mcp` | `pnpm add -g chrome-devtools-mcp` |
| context7-skill | `ctx7` | `pnpm add -g ctx7` |
| excel-skill | `excel-cli` | `cargo install excel-cli --locked` |
| find-skills | `npx skills` | incluido con Node |
| git-ftp-deploy | `git`, `git-ftp`, `pnpm/npm/yarn` | `sudo apt install git-ftp` + gestor de paquetes Node |
| git-ftp-skill | `git`, `git-ftp` | `sudo apt install git-ftp` |
| imagemagick-conversion | `magick` (ImageMagick) | `sudo apt install imagemagick` |
| kanboard-skill | `python3` | nativo |
| laravel-modular-genius | `php`, `composer`, `artisan` | `sudo apt install php composer` |
| lighthouse | `lighthouse`, Chrome/Chromium | `pnpm add -g lighthouse` |
| magic-skill | `@21st-dev/cli` | `pnpm add -g @21st-dev/cli` |
| playwright-cli | `@playwright/cli` | `pnpm add -g @playwright/cli@latest` |
| skill-creator | `python3` | nativo |
| thinking-skill | `sequential-thinking-cli` | `pnpm add -g sequential-thinking-cli` |
| usql-skill | `usql` | descargar release oficial o `go install` |

Instalador de dependencias en Omarchy:
```sh
./install-missing-skill-deps.sh
./install-missing-skill-deps.sh --remove-npm-globals # quitar CLIs de skills instaladas con npm antes de instalar con pnpm
```
