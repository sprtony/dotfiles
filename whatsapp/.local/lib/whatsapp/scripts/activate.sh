#!/usr/bin/env bash
# Toma el control del sync y limpia los enlaces del plugin.
# Ejecutar después de quitar io.github.atoslins.whatsapp. No toca la sesión de
# wacli ni envía nada a WhatsApp.

set -euo pipefail

LIB="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
HELPER="${HOME}/.local/bin/whatsapp"
PLUGIN_DIR="${HOME}/.config/omarchy/plugins/io.github.atoslins.whatsapp"
UNIT_SRC="${LIB}/systemd/user"
UNIT_DST="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
FORCE=0

for arg in "$@"; do
  case "$arg" in
  --force) FORCE=1 ;;
  -h | --help)
    echo "Uso: activate.sh [--force]"
    exit 0
    ;;
  *)
    echo "Opción desconocida: $arg" >&2
    exit 2
    ;;
  esac
done

if [[ -d "$PLUGIN_DIR" && "$FORCE" -ne 1 ]]; then
  echo "El plugin sigue instalado en $PLUGIN_DIR." >&2
  echo "Quítalo primero con: omarchy plugin remove io.github.atoslins.whatsapp --yes" >&2
  echo "Usa --force solo si sabes que el plugin ya no está en uso." >&2
  exit 1
fi

if [[ ! -x "$HELPER" ]]; then
  echo "Falta el helper ejecutable: $HELPER" >&2
  echo "Enlaza el módulo con: cd ~/.dotfiles && stow -v whatsapp" >&2
  exit 1
fi

echo "== Limpiando enlaces del plugin =="
for link in "$HOME/.local/bin/omawhatsapp" "$HOME/.local/bin/omawhatsapp-mcp" \
  "$HOME/.agents/skills/omawhatsapp"; do
  [[ -L "$link" ]] || continue
  raw="$(readlink "$link")"
  if [[ ! -e "$link" || "$raw" == *"/plugins/io.github.atoslins.whatsapp/"* ]]; then
    rm -f "$link"
    echo "borrado: $link -> $raw"
  else
    echo "ajeno, no se toca: $link -> $raw"
  fi
done

echo "== Instalando unidades propias =="
mkdir -p "$UNIT_DST"
stamp="$(date -u +%Y%m%d%H%M%S)"
for unit in wacli-sync.service wacli-sync@.service; do
  src="$UNIT_SRC/$unit"
  dst="$UNIT_DST/$unit"
  [[ -f "$src" ]] || {
    echo "Falta plantilla: $src" >&2
    exit 1
  }
  if [[ -e "$dst" ]] && ! cmp -s "$src" "$dst"; then
    cp -a "$dst" "$dst.bak.$stamp"
    echo "respaldo: $dst.bak.$stamp"
  fi
  install -m 0644 "$src" "$dst"
  echo "instalada: $dst"
done

dropin_dir="$UNIT_DST/wacli-sync@.service.d"
# systemd no lee un directorio de drop-ins que sea symlink. Si stow lo creó
# así en una instalación nueva, se reemplaza por un directorio real.
if [[ -L "$dropin_dir" ]]; then
  rm "$dropin_dir"
fi
mkdir -p "$dropin_dir"
cat >"$dropin_dir/10-whatsapp-exec.conf" <<'EOF'
[Service]
# El helper propio decide si la cuenta tiene sesión vinculada. Sustituye la
# ruta del plugin para que el sync siga funcionando después de desinstalarlo.
ExecCondition=
ExecCondition=%h/.local/bin/whatsapp session-ready --account %i
EOF
echo "instalado: $dropin_dir/10-whatsapp-exec.conf"

systemctl --user daemon-reload

status="$("$HELPER" status)"
if ! jq -e '.any_authenticated == true' >/dev/null <<<"$status"; then
  echo "No hay cuentas autenticadas; no se inician servicios de sync." >&2
  "$HELPER" status | jq '{ok,authenticated,any_authenticated,database_ready}' >&2
  exit 1
fi

units="$(jq -r '.accounts[]? | select(.authenticated == true) | .unit // empty' <<<"$status")"
if ! grep -qx 'wacli-sync.service' <<<"$units"; then
  units=$'wacli-sync.service\n'"$units"
fi

echo "== Activando sync =="
while IFS= read -r unit; do
  [[ -n "$unit" ]] || continue
  if ! systemctl --user cat "$unit" >/dev/null 2>&1; then
    echo "omitida (no existe): $unit" >&2
    continue
  fi
  systemctl --user enable "$unit" >/dev/null
  systemctl --user restart "$unit"
  echo "activa: $unit"
done <<<"$units"

sleep 1
echo "== Verificación =="
"$HELPER" status | jq '{ok,authenticated,database_ready,any_authenticated,
  rail_ready,sync_active,account_count:((.accounts // [])|length),
  accounts:[.accounts[]? | {account,authenticated,sync_active,unit}]}'
echo "Listo. Plugin fuera, helper y sync propios."
