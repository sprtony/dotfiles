# whatsapp

Helper standalone de WhatsApp local, respaldado en dotfiles y enlazado con
stow. No depende del plugin `io.github.atoslins.whatsapp`: solo necesita
`wacli` y esta copia vendorizada.

Origen: <https://github.com/atoslins/Omarchy-WhatsApp-v2>  
Versión fijada: `v0.16.4` (`a61acbb`)  
Licencia: MIT, ver `.local/lib/whatsapp/LICENSE`

## Qué resuelve

El plugin de Omarchy trae la UI QML y, dentro de su carpeta, el helper python,
las unidades systemd, la skill y el MCP. Al desinstalar el plugin se pierden
esos archivos. Este módulo conserva la parte operativa en dotfiles y la enlaza
en `$HOME` con stow.

Dependencia externa real: `wacli` (probado con `0.25.0`, mínimo `0.17.1`).

## Estructura

```
whatsapp/
├── .local/bin/whatsapp            -> ../lib/whatsapp/bin/whatsapp
├── .local/bin/whatsapp-mcp        -> ../lib/whatsapp/bin/whatsapp-mcp
├── .local/lib/whatsapp/
│   ├── bin/                       helper, core, assets, MCP
│   ├── systemd/user/              plantillas propias de sync
│   ├── skills/whatsapp/           skill traducida y ajustada
│   ├── scripts/activate.sh        toma systemd tras quitar el plugin
│   ├── scripts/update-from-plugin.sh
│   ├── manifest.json
│   └── LICENSE
├── .agents/skills/whatsapp        -> ../../.local/lib/whatsapp/skills/whatsapp
├── .config/systemd/user/wacli-sync@.service.d/10-whatsapp-exec.conf
├── docs/UPSTREAM.md
└── docs/RENAMES.md
```

## Instalación

```bash
cd ~/.dotfiles
# systemd no lee un directorio de drop-ins que sea symlink
mkdir -p ~/.config/systemd/user/wacli-sync@.service.d
stow -n -v whatsapp   # simulación
stow -v whatsapp
```

Verificación sin escribir en WhatsApp:

```bash
command -v whatsapp
whatsapp status | jq '{ok,authenticated,database_ready,account_count:((.accounts // [])|length)}'
printf '{"query":"","limit":1}\n' | whatsapp chats
whatsapp session-ready --account Quimaira
```

Nota: `~/.local/lib` no existía antes; stow lo enlaza al módulo. Si algún día
otro paquete quiere usar `~/.local/lib`, revisa ese enlace antes.

## Estado

- wacli store: `~/.local/state/wacli` (sin cambios).
- helper nuevo: `~/.local/state/whatsapp`.
- Durante la transición se copiaron `preferences.json` y `lid-aliases.json`
  desde `~/.local/state/omawhatsapp`. El directorio viejo no se borra.
- Mientras el plugin siga instalado, la UI y este helper pueden tener
  preferencias separadas. El store de mensajes es común.

## Systemd

La unidad de cuenta usa `ExecCondition` para saber si hay sesión vinculada. El
drop-in `10-whatsapp-exec.conf` sustituye la ruta del plugin por
`%h/.local/bin/whatsapp`, así el sync sigue funcionando después de desinstalar
el plugin.

systemd no lee un directorio de drop-ins que sea symlink. Por eso el directorio
`.d` debe ser real antes de stow (ver instalación). `activate.sh` detecta y
corrige ese caso si una instalación nueva lo dejó mal.

Después de quitar el plugin:

```bash
omarchy plugin remove io.github.atoslins.whatsapp --yes
~/.local/lib/whatsapp/scripts/activate.sh
```

`activate.sh` hace, en orden:

1. borra solo enlaces colgando o que apunten al plugin;
2. respalda las unidades existentes y copia las propias;
3. instala el drop-in;
4. `daemon-reload` y reactiva `wacli-sync.service` y las cuentas autenticadas;
5. verifica estado. No toca la sesión de wacli ni envía mensajes.

Si el plugin todavía existe, el script se niega salvo `--force`.

## MCP

El servidor MCP se llama `whatsapp` y vive en `~/.local/bin/whatsapp-mcp`.
Ejemplo de configuración en un cliente MCP local:

```json
{
  "mcp": {
    "whatsapp": {
      "type": "local",
      "command": ["/home/quimaira/.local/bin/whatsapp-mcp"],
      "enabled": true
    }
  }
}
```

Ajusta la ruta si tu home no es `/home/quimaira`. El helper se localiza junto al
servidor; también puedes fijarlo con `WHATSAPP_HELPER`.

## Actualizar desde upstream

El módulo es la fuente de verdad. No edites la copia enlazada como si fuera
código original.

```bash
# Con el plugin todavía instalado, o clonando upstream en otra ruta:
~/.local/lib/whatsapp/scripts/update-from-plugin.sh --dry-run
~/.local/lib/whatsapp/scripts/update-from-plugin.sh

# La skill traducida solo se sobrescribe si lo pides:
~/.local/lib/whatsapp/scripts/update-from-plugin.sh --skill

cd ~/.dotfiles && git diff -- whatsapp
```

El script copia helper, MCP, unidades y metadatos, reaplica los renombrados
documentados en `docs/RENAMES.md` y ejecuta `py_compile`. Revisa el diff, vuelve
a probar lecturas y después commitea.

## Rollback

```bash
cd ~/.dotfiles
stow -D whatsapp
```

Si `activate.sh` ya reemplazó unidades, restaura los respaldos
`~/.config/systemd/user/*.bak.*` y ejecuta `systemctl --user daemon-reload`.
El plugin no se toca: puede reinstalarse con `omarchy plugin add`.

## Comandos no soportados

Esta copia mantiene el helper original, pero la gestión del plugin no aplica:

- `setup` y `teardown`: los enlaces los maneja stow y las unidades
  `activate.sh`.
- `update-check` y `self-update`: las actualizaciones vienen de dotfiles.
- `launch`: abre la UI del plugin, que ya no forma parte de esta instalación.

No los uses. El resto de comandos de WhatsApp y el gateway `wacli` funcionan
igual.

## Seguridad

- Lecturas locales read-only.
- Nunca poner nombres, JIDs, IDs, texto ni rutas de medios en repositorios,
  issues, capturas o logs durables.
- Ninguna escritura de prueba.
- Ningún reintento automático de una mutación que pudo entregarse.
- Los ejemplos de la skill usan datos sintéticos.

Ver `docs/UPSTREAM.md` para procedencia y `docs/RENAMES.md` para los cambios
exactos respecto al helper original.
