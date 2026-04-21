---
name: kanboard
description: Project and task management in Kanboard.
allowed-tools: Bash(bash *)
---

# kanboard-skill

Gestión de proyectos y tareas en Kanboard.

## Workflow Principal

1.  **Listar Proyectos**: Encuentra el `project_id`.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/kanboard get-projects --toon
    ```

2.  **Explorar Tareas**: Obtén tareas por proyecto.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/kanboard get-tasks --project_id <ID> --toon
    ```

3.  **Modificar Tareas**: Cambia el estado o asignado de una tarea.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/kanboard update-task --task_id <ID> --title "Nuevo Título" --toon
    ```

## Optimización
-   Las respuestas de Kanboard suelen ser arrays de objetos grandes. Usa siempre `--toon` para ahorrar tokens significativamente.

