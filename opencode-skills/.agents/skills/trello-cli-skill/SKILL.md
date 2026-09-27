---
name: trello-cli-skill
description: Manage Trello boards, lists, and cards using the `trello-cli`. This skill supports comprehensive Trello operations including creating/updating/moving cards, managing checklists, attachments, comments, and board members. It also supports searching and local caching for faster name-to-ID resolution.
---

# Trello CLI Skill

Esta skill permite a Claude interactuar con Trello utilizando la herramienta `trello-cli`.

## Comandos Principales

### Gestión de Tarjetas (Cards)
- `trello card:list --board "Nombre" --list "Nombre"`: Lista tarjetas.
- `trello card:create --board "Nombre" --list "Nombre" --name "Título"`: Crea una tarjeta.
- `trello card:update --card-id <id> --name "Nuevo Nombre"`: Actualiza una tarjeta.
- `trello card:move --card-id <id> --list-id <id>`: Mueve una tarjeta.
- `trello card:archive --card-id <id>`: Archiva una tarjeta.
- `trello card:assign --card-id <id> --member-id <id>`: Asigna un miembro.
- `trello card:comment --card-id <id> --text "Comentario"`: Añade un comentario.
- `trello card:checklist --card-id <id> --name "Nombre"`: Añade una checklist.
- `trello card:attach --card-id <id> --url <url>`: Añade un adjunto.

### Gestión de Tableros (Boards)
- `trello board:list`: Lista todos los tableros.
- `trello board:create --name "Nombre"`: Crea un tablero.
- `trello board:members --board "Nombre"`: Lista los miembros de un tablero.

### Gestión de Listas (Lists)
- `trello list:list --board "Nombre"`: Lista las listas de un tablero.
- `trello list:create --board "Nombre" --name "Nueva Lista"`: Crea una lista.
- `trello list:move-all-cards --board "Nombre" --from <lista_original> --to <lista_destino>`: Mueve todas las tarjetas entre listas.

### Búsqueda y Utilidades
- `trello search --query "Texto" --type <cards|boards>`: Busca en Trello.
- `trello sync`: **CRÍTICO.** Sincroniza nombres e IDs en un caché local. Ejecútalo si no encuentras un tablero o lista por nombre.

## Flujo de Trabajo Optimizado

### 1. Resolución de Nombres a IDs
La CLI es muy flexible y a menudo acepta `--board "Nombre"` en lugar de IDs. Si un comando falla, intenta usar `trello sync` para actualizar el mapeo local y luego reintenta.

### 2. Formatos de Salida
Puedes usar `--format json` para procesar datos programáticamente si el listado por defecto es difícil de leer.

### 3. Operaciones por Lote
Para tareas complejas (como mover todas las tarjetas), busca si existe un comando específico como `list:move-all-cards` antes de iterar manualmente.

## Notas de Seguridad
- No pidas credenciales; la CLI ya está configurada en `~/.trello-cli/`.
- Prioriza el uso de nombres legibles sobre IDs cuando la CLI lo permita.
