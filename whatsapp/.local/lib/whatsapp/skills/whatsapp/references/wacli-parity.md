# Paridad guardada de wacli

Usa esta referencia para capacidades fuera del helper enfocado de chats:
llamadas, canales, contactos, administración de grupos, historial, recuperación
de medios, encuestas, presencia, perfiles, cuentas, status, sync, exports y
mantenimiento de store.

## Descubrir la superficie instalada

El registro del helper es la fuente de verdad legible por máquina:

```bash
wa="$HOME/.local/bin/whatsapp"
"$wa" capabilities
```

Cubre cada hoja de comando de wacli 0.19.0 y acepta 0.17.1 o superior;
`wacli_minimum_version` y `wacli_parity_version` en la salida dicen cuáles, y
cada operación lleva la release `min_wacli` en la que apareció. Antes de una
operación avanzada, inspecciona sus flags sin cambiar estado:

```bash
wacli <command> <subcommand> --help
```

Las hojas futuras desconocidas fallan cerrado hasta que esta copia las clasifique.

## Contrato no interactivo

Envía un objeto JSON a `whatsapp wacli`:

```json
{
  "args": ["messages", "starred", "--limit", "50"],
  "authorization": "",
  "private_export_authorization": "",
  "repository_export_authorization": "",
  "external_stream_authorization": "",
  "account": "",
  "store": "",
  "timeout": 300,
  "lock_wait": "5s",
  "events": false,
  "full": false,
  "max_output_bytes": 1048576
}
```

Constrúyelo con `jq`; texto de usuario, nombres de archivo, JIDs, teléfonos,
códigos de invitación, URLs y secretos son datos, nunca fuente de shell:

```bash
jq -nc --argjson args '["messages","starred","--limit","50"]' \
  '{args:$args}' | "$wa" wacli
```

Pasa `--account`, `--store`, `--timeout`, `--lock-wait`, `--events` y `--full`
por los campos JSON correspondientes, no dentro de `args`. Nunca pases
`--read-only` ni `--json`; el helper agrega la salida JSON y la aplicación
read-only. Prefiere una `account` con nombre; un `store` puntual debe ser una
ruta absoluta dentro del home del usuario.

La respuesta reporta `ok`, `operation`, `policy` y `data`. Deliberadamente no
repite el arreglo de argumentos, porque puede contener datos privados.

## Clases de autorización

`local-read` necesita una cadena de autorización vacía y corre con el guard
`--read-only` de wacli. Toda otra política primaria requiere un token exacto en
el campo JSON `authorization`; el streaming externo usa el campo adicional
descrito abajo:

| Política | Token | Significado |
|---|---|---|
| `local-read` | `""` | Inspeccionar metadatos/historial local sin escribir |
| `remote-read` | `"remote-read"` | Consultar WhatsApp en vivo y posiblemente refrescar metadatos locales |
| `local-write` | `"local-write"` | Cambiar solo alias/config/metadatos del store local |
| `private-export` | `"private-export:<ruta-absoluta-exacta>"` | Escribir un export privado de mensajes en ese único archivo |
| `external-stream` | `"external-stream:<destino-exacto>"` | Emitir eventos privados a `response` o a una URL de webhook exacta |
| `sync` | `"sync"` | Descargar/sincronizar historial o medios |
| `whatsapp-write` | `"whatsapp-write"` | Enviar o cambiar estado visible de WhatsApp |
| `destructive` | `"destructive"` | Borrar, salir, revocar, eliminar, rechazar o invalidar estado |
| `interactive` | flag CLI | Vincular una cuenta en una terminal |

`private-export` reemplaza a `local-write` para `messages export --output`.
`media download --output` mantiene `authorization:"sync"` y además necesita
`private_export_authorization:"private-export:<ruta-exacta>"`.
`external-stream` es una compuerta adicional: conserva el token ordinario de la
operación en `authorization` y pon el token ligado al destino en
`external_stream_authorization`. Usa `external-stream:response` para
`events:true`. Si una solicitud habilita deliberadamente eventos de respuesta y
un webhook, entrega ambos tokens exactos como arreglo.

Nunca entregues un token solo para que un comando pase. La solicitud actual del
usuario debe autorizar claramente la operación, destino, contenido y alcance
exactos. Una solicitud para inspeccionar datos no autoriza `remote-read`; una
solicitud para sincronizar no autoriza un envío; una solicitud para enviar no
autoriza un status, ni una mutación de grupo/perfil/cuenta.

Ejemplos:

```bash
# Lectura local: sin token.
jq -nc '{args:["calls","list","--limit","20"]}' | "$wa" wacli

# Refresco de metadatos en vivo: solo si el usuario pidió la consulta en vivo.
jq -nc '{args:["groups","info","--jid","EXACT_GROUP_JID"],
  authorization:"remote-read"}' | "$wa" wacli

# Mutación de WhatsApp: solo si el usuario pidió este voto exacto.
jq -nc '{args:["poll","vote","--to","EXACT_CHAT_JID","--id","EXACT_ID",
  "--option","Yes"],authorization:"whatsapp-write"}' | "$wa" wacli
```

Los dry runs de `history fill`, `messages purge` y `store cleanup` se degradan
automáticamente a `local-read`. `messages export --output` requiere el token
`private-export` que nombra el destino. Las rutas de export dentro de un
repositorio Git se rechazan salvo que la solicitud también entregue
`repository_export_authorization:"allow-repository-export:<ruta-exacta>"`;
prefiere un directorio privado fuera de repositorios. Un export nunca reemplaza
un archivo que ya existe en su ruta; elige un nombre nuevo. `doctor --connect`
es `remote-read`.

## Vinculación interactiva y sync en foreground

El modo interactivo hereda la terminal para que el QR/progreso siga visible.
Úsalo solo cuando el usuario pida explícitamente vincular o un sync en
foreground:

```bash
"$wa" wacli --interactive --authorize interactive -- auth
"$wa" wacli --interactive --authorize interactive -- accounts add NAME
"$wa" wacli --interactive --authorize sync -- sync --once
```

El helper pausa el servicio residente de sync por defecto cuando hace falta y lo
restaura después. Nunca anula el modo offline explícito.

## Límites de alto impacto

- Resuelve destinos existentes de chat/grupo/canal/mensaje a identificadores
  exactos antes de mutar. Nunca uses `--pick` para adivinar un resultado
  ambiguo.
- Trata marcar leído como un cambio visible en los dispositivos del usuario (no
  envía recibo al remitente) y la presencia como actividad visible.
- Status, cambios de perfil, membresía/admin de grupo o canal, logout, borrado
  de cuenta, revoke/delete/purge y cleanup requieren autorización actual exacta
  y ningún reintento automático.
- `sync --webhook` requiere `authorization:"sync"` y
  `external_stream_authorization:"external-stream:<url-exacta>"`. Úsalo solo
  cuando el usuario entregue y autorice explícitamente ese destino; nunca
  expongas secretos de webhook en salida o logs durables.
- Exports y medios descargados siguen siendo datos locales privados. No pongas
  salida bajo un repositorio o directorio compartido salvo pedido explícito.
