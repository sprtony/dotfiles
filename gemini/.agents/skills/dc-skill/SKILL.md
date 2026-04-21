---
name: dc
description: Advanced system operations, file editing, and process management.
allowed-tools: Bash(bash *)
---

# dc-skill

Operaciones avanzadas de sistema, edición de archivos y gestión de procesos interactivos.

## Workflow Principal

1.  **Edición Quirúrgica**: Reemplaza bloques de texto con precisión.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/dc edit-block --file_path "/ruta/al/archivo" --old_string "viejo" --new_string "nuevo" --toon
    ```

2.  **Gestión de Procesos**: Inicia y controla procesos de terminal.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/dc start-process --command "python3 -i" --timeout_ms 5000 --toon
    ```

3.  **Generación de PDF**: Crea o modifica documentos PDF.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/dc write-pdf --path "reporte.pdf" --content "# Mi Reporte" --toon
    ```

## Tips de Uso
-   **--toon**: Esencial para respuestas de listas de procesos o contenidos de archivos grandes.
-   **Edición**: Usa `edit-block` para cambios pequeños en lugar de reescribir todo el archivo.

