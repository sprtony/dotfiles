# Procedencia y actualización

## Origen

- Repositorio: <https://github.com/atoslins/Omarchy-WhatsApp-v2>
- Versión copiada: `v0.16.4`
- Commit: `a61acbb` (`chore(main): release 0.16.4`)
- Licencia: MIT (`.local/lib/whatsapp/LICENSE`)
- Fecha de vendorización: 2026-10-26

La copia se tomó del checkout instalado en
`~/.config/omarchy/plugins/io.github.atoslins.whatsapp`, que correspondía a
`v0.16.4`.

## Qué se copió

- `bin/omawhatsapp` → `whatsapp`
- `bin/omawhatsapp_core.py` → `whatsapp_core.py`
- `bin/omawhatsapp_assets.py` → `whatsapp_assets.py`
- `bin/omawhatsapp-mcp` → `whatsapp-mcp`
- `bin/earlier-copies.json`
- `systemd/user/wacli-sync.service`
- `systemd/user/wacli-sync@.service`
- `skills/omawhatsapp/` → `skills/whatsapp/`
- `manifest.json`, `LICENSE`

No se copiaron QML, assets gráficos, tests ni scripts de release del plugin.

## Actualizar

1. Consigue la versión nueva (plugin actualizado o clon upstream).
2. Ejecuta:

   ```bash
   ~/.local/lib/whatsapp/scripts/update-from-plugin.sh --dry-run
   ~/.local/lib/whatsapp/scripts/update-from-plugin.sh
   ```

3. Revisa `cd ~/.dotfiles && git diff -- whatsapp`.
4. Si upstream cambió textos o estructura, ajusta la skill traducida. El script
   no la sobrescribe salvo `--skill`.
5. Prueba sin escribir en WhatsApp:

   ```bash
   python3 -m py_compile ~/.dotfiles/whatsapp/.local/lib/whatsapp/bin/*.py
   whatsapp status
   printf '{"query":"","limit":1}\n' | whatsapp chats
   ```

6. Commitea solo el módulo `whatsapp/`.

## Por qué no se actualiza solo

El helper original se actualiza con `omarchy plugin update`. Esta copia queda
fijada a propósito: una actualización silenciosa podría cambiar rutas,
autorizaciones o textos sin revisión. La actualización es una tarea de dotfiles.

## Compatibilidad con wacli

- Mínimo: `wacli 0.17.1`
- Paridad de registro: hasta `wacli 0.19.0`
- Probado en esta máquina: `wacli 0.25.0`

Hojas nuevas de wacli fallan cerrado hasta que el registro del helper las
clasifique. Si una operación nueva es necesaria, actualiza el helper upstream
antes de usarla.
