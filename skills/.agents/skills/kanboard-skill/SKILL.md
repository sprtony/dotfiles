---
name: kanboard
description: Gestión de proyectos y tareas en Kanboard vía API JSON-RPC directa.
allowed-tools: Bash(bash *)
---

# kanboard-skill

Gestiona proyectos y tareas en Kanboard usando su API JSON-RPC 2.0 directamente.

## Configuración

Credenciales por defecto ya están embebidas. Para sobreescribir:

- `KANBOARD_URL` — endpoint JSON-RPC (default `http://kanboard.avadig.com/jsonrpc.php`)
- `KANBOARD_USER` — usuario (default `jsonrpc`)
- `KANBOARD_TOKEN` — API token

## Workflow Principal

1.  **Listar Proyectos**: Encuentra el `id`.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/kanboard get-projects
    ```

2.  **Ver Tareas**: Obtén tareas por proyecto.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/kanboard get-tasks --project_id <ID>
    ```

3.  **Modificar Tarea**: Cambia título, estado, responsable, columna, color o descripción.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/kanboard update-task --task_id <ID> --title "Nuevo Título"
    ```

## Subcomandos

| Subcomando | Descripción |
|------------|-------------|
| `get-projects` | Lista proyectos (compacto) |
| `get-project --project_id <ID>` | Detalle de un proyecto |
| `get-tasks --project_id <ID>` | Lista tareas abiertas del proyecto |
| `get-board --project_id <ID>` | Devuelve el tablero (board) |
| `create-project --name <NOMBRE>` | Crea un proyecto |
| `create-task --project_id <ID> --title <TÍTULO>` | Crea una tarea |
| `update-task --task_id <ID> [--title ...] [--status ...] [--owner_id ...]` | Actualiza una tarea |

## Opciones

-   `--raw` — devuelve la respuesta completa de Kanboard sin compactar.

## Optimización

-   La salida por defecto ya está compactada para ahorrar tokens.
-   Usa `--raw` solo cuando necesites campos extra no mostrados por defecto.
