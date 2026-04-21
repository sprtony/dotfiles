---
name: serena
description: Symbolic code analysis and editing (LSP-based).
allowed-tools: Bash(bash *)
---

# serena-skill

Análisis simbólico de código y edición basada en LSP.

## Workflow Principal

1.  **Analizar Símbolos**: Obtén un resumen de clases y métodos de un archivo.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/serena get-symbols-overview --relative_path "src/index.ts" --toon
    ```

2.  **Buscar Referencias**: Encuentra dónde se usa un símbolo.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/serena find-referencing-symbols --name_path "MyClass/myMethod" --relative_path "src/myclass.ts" --toon
    ```

3.  **Edición Simbólica**: Reemplaza el cuerpo de un método o función.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/serena replace-symbol-body --name_path "myFunction" --relative_path "src/utils.ts" --body "fun body() { ... }" --toon
    ```

## Recomendaciones
-   **Análisis**: Usa `get-symbols-overview` antes de leer el archivo completo.
-   **--toon**: Crucial para respuestas con múltiples referencias o resúmenes de archivos grandes.

