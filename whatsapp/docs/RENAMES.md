# Renombrados respecto al helper original

Objetivo: que la implementación se llame `whatsapp`, no `omawhatsapp`, sin
romper el contrato de wacli ni los datos.

## Archivos

| Original | Nuevo |
|---|---|
| `bin/omawhatsapp` | `bin/whatsapp` |
| `bin/omawhatsapp_core.py` | `bin/whatsapp_core.py` |
| `bin/omawhatsapp_assets.py` | `bin/whatsapp_assets.py` |
| `bin/omawhatsapp-mcp` | `bin/whatsapp-mcp` |
| `skills/omawhatsapp/` | `skills/whatsapp/` |

## Rutas y comandos

| Original | Nuevo |
|---|---|
| `~/.local/bin/omawhatsapp` | `~/.local/bin/whatsapp` |
| `~/.local/bin/omawhatsapp-mcp` | `~/.local/bin/whatsapp-mcp` |
| `~/.agents/skills/omawhatsapp` | `~/.agents/skills/whatsapp` |
| `~/.local/state/omawhatsapp` | `~/.local/state/whatsapp` |
| `~/.cache/omawhatsapp` | `~/.cache/whatsapp` |
| `10-omawhatsapp-media.conf` | `10-whatsapp-media.conf` |
| `omawhatsapp-session` | `whatsapp-session` |
| `OMAW_HELPER` | `WHATSAPP_HELPER` |
| `argparse prog="omawhatsapp"` | `prog="whatsapp"` |
| `ExecCondition=.../omawhatsapp` | `ExecCondition=.../whatsapp` |

## Qué se conserva a propósito

- `LEGACY_HELPER_COPIES = ("omawhatsapp_core.py", "omawhatsapp_assets.py")`:
  detecta copias históricas que dejaron instaladores viejos.
- `ORIGINAL_PLUGIN_ID = "io.github.moizibnyousaf.omawhatsapp"`: detecta la app
  original para evitar dos sync en conflicto.
- Nombres de unidad `wacli-sync.service` y `wacli-sync@.service`: pertenecen a
  wacli, no a la app.
- Variables de entorno `OMAW_MEDIA_FLAGS`: contrato de las unidades y del
  drop-in de medios.
- Formato JSON, nombres de campos, políticas y tokens de autorización: son
  contrato del helper y de la skill.

## Textos

- `WhatsApp for Omarchy` → `WhatsApp local` en mensajes del helper y del MCP.
- `serverInfo.name`: `whatsapp`.
- Descripciones de unidades y comentarios de sistema en español.
- Skill y referencias traducidas al español; los bloques de código y los
  contratos técnicos no cambian.

## Verificación tras un renombrado

```bash
rg -n "omawhatsapp" ~/.dotfiles/whatsapp/.local/lib/whatsapp/bin
```

Solo deben quedar las excepciones históricas listadas arriba.
