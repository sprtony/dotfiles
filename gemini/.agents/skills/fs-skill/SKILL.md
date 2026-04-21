---
name: fs
description: Manage files and directories on the local system.
allowed-tools: Bash(bash *)
---

# fs-skill

Gestión de archivos y carpetas del sistema local.

## Workflow Principal

1.  **Listar Directorios**: Explora el contenido de carpetas.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/fs list-directory --path "/home/quimaira/" --toon
    ```

2.  **Leer Archivos**: Accede al contenido de archivos de texto.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/fs read-text-file --path "/ruta/archivo.txt" --toon
    ```

3.  **Buscar Archivos**: Encuentra archivos por patrón.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/fs search-files --path "/home/quimaira/" --pattern "*.md" --toon
    ```

## Recomendaciones
-   **Ahorro de Tokens**: Las listas de archivos pueden ser muy largas. Usa siempre `--toon`.
-   **Uso Quirúrgico**: Prefiere `edit-file` para modificaciones línea por línea.

