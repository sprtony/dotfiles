#!/usr/bin/env bash
set -Eeuo pipefail

# Instala las herramientas CLI del perfil mac.
# Uso: ./scripts/mac/install-tools.sh
# Idempotente: solo instala lo que falta.

print_error() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

command_exists brew || print_error 'No encuentro brew; instálalo desde https://brew.sh'

# Formulae: "formula:comando-a-comprobar"
brew_formulae=(
  'git-lfs:git-lfs'
  'git-ftp:git-ftp'
  'stow:stow'
  'ripgrep:rg'
  'fd:fd'
  'bat:bat'
  'lsd:lsd'
  'fzf:fzf'
  'mise:mise'
  'zoxide:zoxide'
  'git-delta:delta'
  'lazygit:lazygit'
  'lazydocker:lazydocker'
  'imagemagick:magick'
  'sevenzip:7zz'
  'usql:usql'
  'bat-extras:batman'
)

to_install=()
for entry in "${brew_formulae[@]}"; do
  formula="${entry%%:*}"
  cmd="${entry#*:}"
  if ! command_exists "$cmd"; then
    to_install+=("$formula")
  fi
done

if ((${#to_install[@]})); then
  printf 'Instalando con brew: %s\n' "${to_install[*]}"
  brew install "${to_install[@]}"
else
  printf 'Formulae brew: ya están instaladas.\n'
fi

# git-lfs global
if command_exists git-lfs; then
  git lfs install >/dev/null 2>&1 || true
fi

# 7z: brew instala 7zz; creamos el alias 7z
if command_exists 7zz && ! command_exists 7z; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v 7zz)" "$HOME/.local/bin/7z"
  printf 'Creado symlink 7z -> 7zz en ~/.local/bin\n'
fi

# php/composer en macOS vienen de Herd (no de brew)

# Paquetes Node globales (deps de skills) con pnpm
command_exists pnpm || print_error 'No encuentro pnpm; instálalo primero.'

# Alinear PNPM_HOME con ~/.shared_env (donde el repo espera los globales)
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
export PATH="$PNPM_HOME/bin:$PATH"

node_globals=(
  lighthouse
  '@playwright/cli'
  ctx7
  'chrome-devtools-mcp'
  '@21st-dev/cli'
  'sequential-thinking-cli'
)

pnpm_installed="$(pnpm list --global --depth=0 2>/dev/null || true)"
node_to_install=()
for pkg in "${node_globals[@]}"; do
  if [[ "$pnpm_installed" != *"$pkg"* ]]; then
    node_to_install+=("$pkg")
  fi
done

if ((${#node_to_install[@]})); then
  printf 'Instalando globales Node con pnpm: %s\n' "${node_to_install[*]}"
  pnpm add --global "${node_to_install[@]}"
else
  printf 'Globales Node: ya están instalados.\n'
fi

printf '\nInstalación de herramientas finalizada.\n'
printf 'Nota: warp es app GUI (no CLI). php/composer van por Herd.\n'
