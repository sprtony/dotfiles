#!/usr/bin/env bash

set -Eeuo pipefail

print_error() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

remove_npm_globals=false
case "${1:-}" in
  '') ;;
  --remove-npm-globals) remove_npm_globals=true ;;
  --help|-h)
    printf 'Uso: %s [--remove-npm-globals]\n' "$0"
    printf '  --remove-npm-globals  Quita CLIs de skills instaladas con npm antes de instalarlas con pnpm.\n'
    exit 0
    ;;
  *) print_error "Opción desconocida: $1" ;;
esac

if [[ "$remove_npm_globals" == true ]]; then
  if command_exists npm && command_exists node; then
    npm_global_json="$(npm list --global --depth=0 --json 2>/dev/null || true)"
    mapfile -t npm_skill_packages < <(
      node -e '
        let input = "";
        process.stdin.on("data", chunk => input += chunk);
        process.stdin.on("end", () => {
          let dependencies = {};
          try {
            dependencies = JSON.parse(input).dependencies || {};
          } catch {}
          for (const name of process.argv.slice(1)) {
            if (Object.prototype.hasOwnProperty.call(dependencies, name)) {
              console.log(name);
            }
          }
        });
      ' lighthouse '@playwright/cli' ctx7 <<< "$npm_global_json"
    )

    if ((${#npm_skill_packages[@]})); then
      printf 'Quitando instalaciones npm globales: %s\n' "${npm_skill_packages[*]}"
      npm uninstall --global "${npm_skill_packages[@]}"
    else
      printf 'No hay CLIs de skills instaladas globalmente con npm.\n'
    fi
  else
    printf 'npm/node no disponibles; no hay instalaciones npm que quitar.\n'
  fi
fi

if [[ ! -e /etc/arch-release ]]; then
  print_error 'Este instalador está preparado para Omarchy/Arch Linux.'
fi

command_exists pacman || print_error 'No encuentro pacman.'

arch_packages=()

command_exists pip || command_exists pip3 || arch_packages+=(python-pip)
command_exists php || arch_packages+=(php)
command_exists composer || arch_packages+=(composer)
command_exists go || arch_packages+=(go)
command_exists 7z || arch_packages+=(7zip)

if command_exists python3 && ! python3 -c 'import requests' >/dev/null 2>&1; then
  arch_packages+=(python-requests)
fi

if ((${#arch_packages[@]})); then
  printf 'Instalando paquetes Arch: %s\n' "${arch_packages[*]}"
  if ((EUID == 0)); then
    pacman -S --needed "${arch_packages[@]}"
  else
    command_exists sudo || print_error 'Necesito sudo para instalar paquetes Arch.'
    sudo pacman -S --needed "${arch_packages[@]}"
  fi
else
  printf 'Paquetes Arch: ya están instalados.\n'
fi

command_exists pnpm || print_error 'No encuentro pnpm; instala pnpm primero.'

node_global_packages=()
pnpm_global_packages="$(pnpm list --global --depth=0 2>/dev/null || true)"
for package_name in lighthouse @playwright/cli ctx7 chrome-devtools-mcp @21st-dev/cli sequential-thinking-cli; do
  if [[ "$pnpm_global_packages" != *"$package_name"* ]]; then
    node_global_packages+=("$package_name")
  fi
done

if ((${#node_global_packages[@]})); then
  printf 'Instalando paquetes globales de Node con pnpm: %s\n' "${node_global_packages[*]}"
  pnpm add --global "${node_global_packages[@]}"
else
  printf 'Paquetes globales de Node: ya están instalados con pnpm.\n'
fi

if ! command_exists excel-cli; then
  command_exists cargo || print_error 'No encuentro cargo; instala Rust primero.'
  printf 'Instalando excel-cli con Cargo.\n'
  cargo install --locked excel-cli
else
  printf 'excel-cli: ya está instalado.\n'
fi

if ! command_exists usql; then
  command_exists go || print_error 'No encuentro Go; instala el paquete go.'
  install_dir="${GOBIN:-$HOME/.local/bin}"
  mkdir -p "$install_dir"
  printf 'Instalando usql en %s.\n' "$install_dir"
  GOBIN="$install_dir" go install github.com/xo/usql@latest
else
  printf 'usql: ya está instalado.\n'
fi

printf '\nInstalación de dependencias finalizada.\n'
printf 'mcp2cli y cli-anything fueron excluidas.\n'
printf 'Nota: wrappers de Chrome DevTools, Magic y Thinking pueden apuntar a rutas pnpm antiguas; reinstalar paquetes no repara esos wrappers.\n'
