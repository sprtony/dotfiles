---
name: magic
description: Discover and retrieve Magic UI components and styles.
allowed-tools: Bash(bash *)
---

# magic-skill

Explora y obtén componentes y estilos de Magic UI.

## Workflow Principal

1.  **Listar Componentes**: Mira qué hay disponible.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/magic list-registry-items --limit 10 --toon
    ```

2.  **Buscar Específicos**: Encuentra componentes por palabra clave.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/magic search-registry-items --query "button" --toon
    ```

3.  **Ver Detalles**: Obtén el código fuente de un componente.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/magic get-registry-item --name "animated-beam" --includeSource true --toon
    ```

## Ahorro de Tokens
-   El código fuente de los componentes puede ser extenso. El flag `--toon` ayuda a mantener el contexto bajo control.

