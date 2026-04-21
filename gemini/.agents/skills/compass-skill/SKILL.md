---
name: compass
description: Recommend and find external MCP servers.
allowed-tools: Bash(bash *)
---

# compass-skill

Este skill permite descubrir servidores MCP externos utilizando MCP-Compass.

## Workflow Principal

1.  **Buscar Servidores**: Encuentra servidores MCP por descripción.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/compass recommend-mcp-servers --query "servidor MCP para AWS" --toon
    ```

## Recomendaciones de Uso
-   Usa `--toon` para recibir resultados en un formato eficiente en tokens.
-   Sé específico en la `--query` para obtener mejores recomendaciones.

