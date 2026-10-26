---
name: whatsapp
description: Inspecciona, busca, resume, sincroniza y opera WhatsApp local vía wacli, con paridad completa y guardrails para mensajes, medios, chats, grupos, canales, llamadas, contactos, historial, perfiles, cuentas y mantenimiento.
---

# WhatsApp local

Implementación standalone, respaldada en `~/.dotfiles/whatsapp` y enlazada con
stow. No depende del plugin de Omarchy: solo necesita `wacli` y la copia
vendorizada del helper.

Cuando el servidor MCP `whatsapp` (`~/.local/bin/whatsapp-mcp`) esté conectado,
prefiere sus herramientas: llaman al helper con la clase de autorización
correcta y aplican los mismos límites. Si no, usa el helper directo.

Usa `~/.local/bin/whatsapp`. Sus comandos enfocados mantienen el trabajo
ordinario dentro del límite local de DMs y grupos standalone. Su gateway
`wacli` cubre todas las hojas del wacli soportado sin exponer un passthrough
arbitrario. Prefiere el helper antes que invocar `wacli` directo.

## Ruta de la solicitud

- Para una operación de WhatsApp en runtime, sigue el flujo con guardrails.
- Para código, tests, despliegue, release o publicación, trabaja en
  `~/.dotfiles/whatsapp`. Nunca edites esta copia instalada como si fuera
  fuente: cambia el módulo de dotfiles, vuelve a enlazar y prueba. Usa solo
  datos sintéticos o de demo para evidencia pública. La autorización de
  runtime no autoriza escrituras de repositorio, pushes, despliegues ni
  releases.
- Las actualizaciones de esta implementación se hacen en el repositorio de
  dotfiles, no desde WhatsApp y no con `self-update`.

## Límite de seguridad

- Las lecturas locales son read-only. Nunca inspecciones `session.db`, escribas
  `wacli.db` ni raspes WhatsApp Web.
- Trata nombres, JIDs, IDs de mensaje, texto y rutas de medios como privados.
  Nunca los pongas en repositorios, issues, capturas o logs durables.
- Resuelve el destino de un chat existente antes de mutarlo; nunca inventes un
  JID, uses un nombre ambiguo o infieras un destinatario. Códigos de invitación,
  nombres de grupo nuevos, teléfonos, ubicaciones, valores de perfil y
  audiencias de status deben venir de la solicitud actual o de una lectura
  inequívoca.
- Lecturas externas, escrituras locales, exportaciones privadas, streams de
  eventos externos, sync/historial, escrituras a WhatsApp, acciones
  destructivas y vinculación interactiva son clases de autorización separadas.
  Los tokens de export/stream también nombran su destino exacto. Usa un token
  solo cuando la solicitud actual autorice esa clase y operación exactas. La
  paridad completa nunca concede permiso permanente.
- Nunca crees una escritura de prueba. Nunca reintentes automáticamente un
  envío, voto, reacción, edición, borrado, cambio de membresía, perfil, status,
  canal/grupo o mutación de cuenta que pudo haberse entregado.
- Leer un chat con el helper nunca lo marca como leído. Marca leído/no leído, o
  cambia la preferencia de lectura automática, solo tras una solicitud
  explícita; el teléfono muestra el cambio.
- Respeta el modo offline. No actives sync en background solo para completar
  otra acción. Las lecturas locales y el mantenimiento local solicitado pueden
  continuar; lecturas remotas, sync y mutaciones deben detenerse.
- Reporta un resultado parcial multiarchivo con exactitud y detente. No
  reintentes una mutación que pudo haberse entregado.
- Trata exports, webhooks, streams, rutas de medios, stores de cuenta y
  resultados de comandos como privados. Nunca los pongas en repositorios,
  issues, capturas o logs durables.
- Status y logs crudos pueden contener etiquetas de cuenta, rutas de store y
  otro contexto privado. Proyecta solo los campos mínimos necesarios.

## Flujo

1. Para una operación de runtime, revisa autenticación, base local y estado
   online/offline sin retener datos de cuenta o store:

   ```bash
   "$HOME/.local/bin/whatsapp" status | jq \
     '{ok,installed,authenticated,database_ready,any_authenticated,
       any_database_ready,rail_ready,sync_active,online,offline_mode,
       account_count:((.accounts // [])|length)}'
   ```

2. Usa los comandos enfocados del helper para lecturas y escrituras ordinarias.
   Resuelve un chat y un mensaje locales exactos antes de cualquier mutación.
3. Para canales, llamadas, contactos, historial, administración de grupos,
   perfiles, cuentas, store u otra operación avanzada, lee
   [references/wacli-parity.md](references/wacli-parity.md). Inspecciona
   `whatsapp capabilities` y el `wacli ... --help` relevante antes de construir
   el arreglo JSON de argumentos.
4. Invoca una operación acotada con la clase de autorización requerida. Usa
   modo interactivo solo para vincular una cuenta o para un sync en foreground
   solicitado por el usuario.
5. Inspecciona el resultado JSON. Reporta éxito solo cuando `ok` sea true; si
   no, muestra el error saneado y detente.

Lee [references/operations.md](references/operations.md) para los contratos de
chat, mensaje, adjuntos, notificaciones y modo offline. Lee
[references/wacli-parity.md](references/wacli-parity.md) para la cobertura
avanzada de wacli y las clases de autorización.
