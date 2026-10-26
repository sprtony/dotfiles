#!/usr/bin/env bash
# Copia una versión nueva del helper desde el checkout del plugin y reaplica
# los renombrados de esta copia standalone. Revisa el diff antes de commitear.
# La skill traducida NO se sobrescribe salvo con --skill.

set -euo pipefail

LIB="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$HOME/.config/omarchy/plugins/io.github.atoslins.whatsapp"
WITH_SKILL=0
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
  --skill) WITH_SKILL=1 ;;
  --dry-run) DRY_RUN=1 ;;
  -h | --help)
    echo "Uso: update-from-plugin.sh [origen] [--skill] [--dry-run]"
    exit 0
    ;;
  -*)
    echo "Opción desconocida: $1" >&2
    exit 2
    ;;
  *)
    SRC="$1"
    ;;
  esac
  shift
done

[[ -f "$SRC/bin/omawhatsapp_core.py" ]] || {
  echo "No parece un checkout del plugin: $SRC" >&2
  exit 1
}

echo "origen: $SRC"
if git -C "$SRC" rev-parse --git-dir >/dev/null 2>&1; then
  echo "versión: $(git -C "$SRC" describe --tags --always 2>/dev/null || true)"
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "dry-run: no se copia nada"
  exit 0
fi

BIN="$LIB/bin"
install -m 0755 "$SRC/bin/omawhatsapp" "$BIN/whatsapp"
install -m 0644 "$SRC/bin/omawhatsapp_core.py" "$BIN/whatsapp_core.py"
install -m 0644 "$SRC/bin/omawhatsapp_assets.py" "$BIN/whatsapp_assets.py"
install -m 0755 "$SRC/bin/omawhatsapp-mcp" "$BIN/whatsapp-mcp"
install -m 0644 "$SRC/bin/earlier-copies.json" "$BIN/earlier-copies.json"
install -m 0644 "$SRC/manifest.json" "$LIB/manifest.json"
install -m 0644 "$SRC/LICENSE" "$LIB/LICENSE"
install -m 0644 "$SRC/systemd/user/wacli-sync.service" "$LIB/systemd/user/wacli-sync.service"
install -m 0644 "$SRC/systemd/user/wacli-sync@.service" "$LIB/systemd/user/wacli-sync@.service"

case "$(uname -s)" in
Linux) PYTHON=python3 ;;
*) PYTHON=python3 ;;
esac

perl -pi -e 's/omawhatsapp_assets/whatsapp_assets/g' "$BIN/whatsapp_core.py"
perl -pi -e 's/"omawhatsapp_core\.py", "whatsapp_assets\.py"/"omawhatsapp_core.py", "omawhatsapp_assets.py"/' "$BIN/whatsapp_core.py"
perl -pi -e 's{STATE_HOME / "omawhatsapp"}{STATE_HOME / "whatsapp"}' "$BIN/whatsapp_core.py"
perl -pi -e 's{\.agents" / "skills" / "omawhatsapp"}{.agents" / "skills" / "whatsapp"}' "$BIN/whatsapp_core.py"
perl -pi -e 's/10-omawhatsapp-media\.conf/10-whatsapp-media.conf/g' "$BIN/whatsapp_core.py"
perl -pi -e 's/CLIPBOARD_STAGE_DIRECTORY = "omawhatsapp"/CLIPBOARD_STAGE_DIRECTORY = "whatsapp"/' "$BIN/whatsapp_core.py"
perl -pi -e 's/self\.local_bin \/ "omawhatsapp"/self.local_bin \/ "whatsapp"/g' "$BIN/whatsapp_core.py"
perl -pi -e 's/self\.plugin_root \/ "bin" \/ "omawhatsapp"/self.plugin_root \/ "bin" \/ "whatsapp"/g' "$BIN/whatsapp_core.py"
perl -pi -e 's/self\.plugin_root \/ "bin" \/ "omawhatsapp-mcp"/self.plugin_root \/ "bin" \/ "whatsapp-mcp"/g' "$BIN/whatsapp_core.py"
perl -pi -e 's/self\.plugin_root \/ "skills" \/ "omawhatsapp"/self.plugin_root \/ "skills" \/ "whatsapp"/g' "$BIN/whatsapp_core.py"
perl -pi -e 's/self\.local_bin \/ "omawhatsapp-mcp"/self.local_bin \/ "whatsapp-mcp"/g' "$BIN/whatsapp_core.py"
perl -pi -e 's/with_name\("omawhatsapp"\)/with_name("whatsapp")/g' "$BIN/whatsapp_core.py"
perl -pi -e 's/"omawhatsapp-session"/"whatsapp-session"/g' "$BIN/whatsapp_core.py"
perl -pi -e 's/Use omawhatsapp wacli/Use whatsapp wacli/g' "$BIN/whatsapp_core.py"
perl -pi -e 's/prog="omawhatsapp"/prog="whatsapp"/' "$BIN/whatsapp_core.py"
perl -pi -e 's/the `omawhatsapp` command/the `whatsapp` command/' "$BIN/whatsapp_core.py"
perl -pi -e 's/a link that puts `omawhatsapp` on the command line/a link that puts `whatsapp` on the command line/' "$BIN/whatsapp_core.py"

perl -pi -e 's/omawhatsapp_core/whatsapp_core/g; s/omawhatsapp_assets/whatsapp_assets/g' "$BIN/whatsapp"
perl -pi -e 's/"omawhatsapp", "pycache"/"whatsapp", "pycache"/' "$BIN/whatsapp"

perl -pi -e 's/WhatsApp for Omarchy/WhatsApp local/g' "$BIN/whatsapp_core.py" "$BIN/whatsapp" "$BIN/whatsapp-mcp"
perl -pi -e 's/``omawhatsapp``/``whatsapp``/g; s/"OMAW_HELPER"/"WHATSAPP_HELPER"/g; s/with_name\("omawhatsapp"\)/with_name("whatsapp")/g; s/"name": "omawhatsapp"/"name": "whatsapp"/' "$BIN/whatsapp-mcp"

perl -pi -e 's/Keep the local WhatsApp for Omarchy index and new media in sync for account %I/Mantiene sincronizado el índice local de WhatsApp para la cuenta %I/' "$LIB/systemd/user/wacli-sync@.service"
perl -pi -e 's/Keep the local WhatsApp for Omarchy index and new media in sync/Mantiene sincronizado el índice local de WhatsApp y los medios nuevos/' "$LIB/systemd/user/wacli-sync.service"
perl -pi -e 's/10-omawhatsapp-media\.conf/10-whatsapp-media.conf/g' "$LIB/systemd/user/wacli-sync.service" "$LIB/systemd/user/wacli-sync@.service"
perl -pi -e 's{%h/\.local/bin/omawhatsapp session-ready}{%h/.local/bin/whatsapp session-ready}g' "$LIB/systemd/user/wacli-sync@.service"

if [[ "$WITH_SKILL" -eq 1 ]]; then
  rm -rf "$LIB/skills/whatsapp"
  cp -a "$SRC/skills/omawhatsapp" "$LIB/skills/whatsapp"
  perl -pi -e 's/omawhatsapp/whatsapp/g' "$LIB/skills/whatsapp/SKILL.md" \
    "$LIB/skills/whatsapp/references/"*.md "$LIB/skills/whatsapp/agents/openai.yaml"
  echo "skill copiada: revisa la traducción antes de commitear"
fi

if git -C "$SRC" rev-parse --git-dir >/dev/null 2>&1; then
  git -C "$SRC" describe --tags --always 2>/dev/null >"$LIB/upstream-version.txt" || true
fi

"$PYTHON" -m py_compile "$BIN/whatsapp_core.py" "$BIN/whatsapp_assets.py"
echo "helper actualizado. Revisa: cd ~/.dotfiles && git diff -- whatsapp"
