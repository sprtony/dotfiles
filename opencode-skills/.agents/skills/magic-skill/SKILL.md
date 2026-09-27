---
name: magic
description: Explora y obtén componentes y estilos de 21st.dev (antes Magic UI) desde el CLI nativo.
allowed-tools: Bash(bash *)
---

# magic-skill

Explora y obtén componentes y estilos de 21st.dev usando el CLI nativo.

## Workflow Principal

1.  **Buscar Componentes**: Encuentra componentes por palabra clave.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/magic search button --limit 10
    ```

2.  **Ver Detalles**: Obtén el código de un componente por su id.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/magic get <id>
    ```

3.  **Instalar Componente**: Añade un componente publicado al proyecto.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/magic add <autor>/<slug>
    ```

## Comandos Útiles

| Comando | Descripción |
|---------|-------------|
| `search <query>` | Busca componentes, themes o templates |
| `get <id>` | Muestra código + demo de un componente |
| `add <autor>/<slug>` | Instala un componente publicado |
| `logo <query>` | Busca logos SVG de marca/UI |
| `theme <id>` | Muestra CSS de un tema |

## Ahorro de Tokens

-   El código fuente de componentes puede ser extenso. Prefiere leer el `id` con `search` y luego `get` solo del componente elegido.
-   Usa `--json` para output estructurado si necesitas parsear la respuesta.
