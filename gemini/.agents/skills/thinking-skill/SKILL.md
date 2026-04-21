---
name: thinking
description: Sequential thinking for complex problem solving.
allowed-tools: Bash(bash *)
---

# thinking-skill

Proceso de pensamiento secuencial para resolver problemas complejos paso a paso.

## Workflow Principal

1.  **Iniciar Pensamiento**: Define el primer paso de tu análisis.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/thinking sequentialthinking --thought "Analizar arquitectura" --thoughtNumber 1 --totalThoughts 5 --nextThoughtNeeded true --toon
    ```

## Uso Recomendado
-   Usa `--toon` para que los resúmenes del proceso de pensamiento sean ligeros en tokens.

