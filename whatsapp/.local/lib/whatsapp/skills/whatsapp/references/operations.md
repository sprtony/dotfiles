# Operaciones enfocadas de WhatsApp local

Todos los comandos usan el helper instalado y emiten un objeto JSON. Construye
las solicitudes con `jq` para que el contenido del usuario sea dato, no sintaxis
de shell.

```bash
wa="$HOME/.local/bin/whatsapp"
```

## Cuentas

Cada solicitud puede llevar `account`, nombrando una cuenta configurada de
wacli. Un valor vacío o ausente significa la cuenta por defecto. `status`
reporta las cuentas configuradas y `chats` devuelve un rail fusionado donde cada
fila lleva la `account` de origen. Un destino de chat se resuelve dentro del
espejo de su propia cuenta, así que devuelve la `account` exacta que reportó la
fila antes de mutarla:

```bash
jq -nc --arg jid "$resolved_jid" --arg account "$row_account" --arg text "$message" \
  '{account:$account,jid:$jid,text:$text}' | "$wa" send
```

Nunca envíes a un JID resuelto desde el rail de otra cuenta.

Los chips de cuenta de la interfaz gráfica son un filtro de vista local y nunca
autorizan un cambio de destino. La vinculación de cuenta es interactiva y debe
pedirse explícitamente:

```bash
"$wa" link-account NAME --authorize interactive
```

En una instalación legacy de una sola cuenta, el store raíz existente queda
intacto y sigue siendo direccionable como `primary` mientras se vincula la
cuenta con nombre solicitada. Nunca inventes el nombre de cuenta ni reintentes
un flujo QR cancelado o incierto.

## Operaciones read-only

Status no necesita stdin:

```bash
"$wa" status
```

Busca en el rail acotado de chats y exige exactamente un resultado deseado
antes de usar el `jid` devuelto:

```bash
jq -nc --arg query "$requested_name" '{query:$query}' \
  | "$wa" chats --limit 500
```

Lee o busca una conversación exacta:

```bash
jq -nc --arg jid "$resolved_jid" --arg query "$requested_query" \
  '{jid:$jid,query:$query}' | "$wa" messages --limit 240
```

Miembros del grupo y candidatos a mención:

```bash
jq -nc --arg jid "$resolved_jid" '{jid:$jid}' | "$wa" members
```

## Mutaciones externas de WhatsApp

Requieren una solicitud actual claramente autorizada y modo online.

Enviar texto (ID de respuesta opcional y JIDs de mención verificados):

```bash
jq -nc --arg jid "$resolved_jid" --arg text "$message" \
  --arg reply "$reply_id" --argjson mentions "$mention_jids_json" \
  '{jid:$jid,text:$text,reply_id:$reply,mentions:$mentions}' \
  | "$wa" send
```

Enviar archivos locales; usa rutas absolutas o URLs `file://`, máximo 10:

```bash
jq -nc --arg jid "$resolved_jid" --arg caption "$caption" \
  --argjson paths "$local_paths_json" \
  '{jid:$jid,caption:$caption,paths:$paths}' | "$wa" files
```

Los demás comandos acotados de mensaje aceptan estos objetos:

| Comando | Campos JSON |
|---|---|
| `react` | `jid`, `id`, `emoji` |
| `edit` | `jid`, `id`, `text` |
| `delete` | `jid`, `id`, `for_me` |
| `forward` | `jid`, `id`, `to_jid` |
| `media` | `jid`, `id` |
| `sticker` | `jid`, `path`, `reply_id` opcional |
| `voice` | `jid`, `path` de un borrador de voz privado, `reply_id` opcional |
| `poll` | `jid`, `question`, `options`, `multi` |
| `select` | `jid`, `id`, `index` |

Solo el cliente gráfico crea y finaliza borradores de voz privados. Los agentes
no deben fabricar una ruta de borrador ni grabar el micrófono implícitamente.
Para un archivo de audio preexistente pedido explícitamente, usa la operación
guardada `wacli send voice` con la autorización exacta `whatsapp-write`
descrita en [wacli-parity.md](wacli-parity.md).

El estado de chat usa una acción permitida:

```bash
jq -nc --arg jid "$resolved_jid" --arg action "$action" \
  '{jid:$jid,action:$action}' | "$wa" chat-action
```

Las acciones permitidas son `read`, `unread`, `pin`, `unpin`, `archive`,
`unarchive`, `mute`, `unmute` y `remove-local` (`remove-local` purga el chat y
sus mensajes del almacenamiento local sin modificar los servidores de WhatsApp).
`read` y `unread` cambian el estado de lectura del chat en los dispositivos del
usuario mediante app state de WhatsApp; no llega ningún recibo de lectura al
remitente. La inspección local nunca las llama.

## Estado local de la app

Inspecciona preferencias privadas sin cambiarlas:

```bash
printf '{}\n' | "$wa" settings
```

Las claves soportadas son `send_read_receipts` (marca leído el chat abierto;
`true` por defecto desde la versión 3 de preferencias, por cuenta),
`read_on_reply`, `enter_sends`, `show_avatars`, `auto_refresh_avatars`,
`rail_density` (`comfortable` o `compact`), `show_unread_count`, `dropdown_rows`
(`5`, `7` o `9`), `composer_max_lines` (`4`, `6`, `8` o `10`, por defecto `6`) y
`time_format` (`auto`, `12h` o `24h`, por defecto `auto`). El formato de hora es
global; `auto` sigue el locale del sistema en previews, mensajes y el visor de
medios. Cámbialas solo cuando el usuario lo pida explícitamente; por ejemplo:

```bash
printf '{"settings":{"send_read_receipts":false}}\n' | "$wa" settings
```

Descarta el lote actual de notificaciones sin cambiar el estado no leído de
WhatsApp:

```bash
printf '{}\n' | "$wa" acknowledge
```

Una solicitud vacía limpia el badge agregado de todas las cuentas. Pasa
`{"account":"...","jid":"..."}` para confirmar un chat exacto. Es un cambio de
estado local, no un recibo, pero hazlo solo si se pidió.

Cambia el sync en background solo si se pide:

```bash
printf '{"online":false}\n' | "$wa" sync-mode
printf '{"online":true}\n' | "$wa" sync-mode
```

El modo offline detiene y deshabilita el servicio de sync de esa cuenta,
conservando las lecturas locales. Bloquea las mutaciones de WhatsApp de esa
cuenta hasta que el usuario vuelva a online y deja intactas las demás cuentas.

## Notificaciones de escritorio

Inspecciona solo el estado no identificable de notificaciones:

```bash
"$wa" status | jq '{notifications,notify_available}'
```

Cambia notificaciones solo cuando el usuario lo pida explícitamente:

```bash
printf '{"enabled":true,"preview":false}\n' | "$wa" notify-mode
printf '{"preview":true}\n' | "$wa" notify-mode
printf '{"enabled":false}\n' | "$wa" notify-mode
```

Con notificaciones activas, los popups futuros envían el nombre del chat y, en
configuraciones multi-cuenta, la etiqueta de cuenta al daemon de notificaciones;
el daemon puede retenerlos en su historial. Con previews activos, los nombres de
remitente y el texto también cruzan ese límite. La app residente posee el barrido
`notify`; nunca lo invoques como prueba sobre un archivo real. Usa datos demo o
mocks al probar notificaciones.

La vinculación de cuenta es interactiva y debe pedirse explícitamente:

```bash
"$wa" wacli --interactive --authorize interactive -- auth
```

La actualización de fotos de perfil es una lectura remota explícita separada.
Opera sobre un lote acotado de chats recientes, guarda solo rutas de caché local
privadas y no debe usarse solo porque se abrió o inspeccionó un chat:

```bash
printf '{"authorization":"remote-read","limit":12}\n' | "$wa" avatars
```

Para llamadas, canales, contactos, administración de grupos, historial/backfill,
recuperación de medios, votos de encuestas, presencia, perfiles, cuentas,
status, exports o mantenimiento de store, usa el gateway clasificado completo en
[wacli-parity.md](wacli-parity.md).
