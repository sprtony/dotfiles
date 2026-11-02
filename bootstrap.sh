#!/usr/bin/env bash
set -Eeuo pipefail

# Instala (o reinstala) los módulos stow del perfil indicado.
# Uso: ./bootstrap.sh omarchy|mac [--restow]

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
profile="${1:-}"
restow="${2:-}"

if [[ -z "$profile" ]]; then
  printf 'Uso: %s <omarchy|mac> [--restow]\n' "$(basename "$0")" >&2
  exit 1
fi

profile_file="$root/profiles/$profile.list"
if [[ ! -f "$profile_file" ]]; then
  printf 'Error: no existe el perfil %s (%s)\n' "$profile" "$profile_file" >&2
  exit 1
fi

if ! command -v stow >/dev/null 2>&1; then
  printf 'Error: falta stow. Instálalo antes de continuar.\n' >&2
  exit 1
fi

if [[ "$root" != "$HOME/.dotfiles" ]]; then
  printf 'Error: el repo debe estar en %s (ahora está en %s).\n' "$HOME/.dotfiles" "$root" >&2
  printf 'Los symlinks del repo son relativos a esa ruta.\n' >&2
  exit 1
fi

# shellcheck disable=SC2207
modules=($(<"$profile_file"))

printf 'Perfil: %s\n' "$profile"
printf 'Módulos: %s\n' "${modules[*]}"

args=(--target "$HOME" --dir "$root")
if [[ "$restow" == "--restow" ]]; then
  args+=(--restow)
fi

stow "${args[@]}" "${modules[@]}"
printf 'OK: perfil %s aplicado.\n' "$profile"
