---
name: context7
description: Query up-to-date documentation and code examples from Context7.
allowed-tools: Bash(bash *)
---

# context7-skill

Accede a documentación actualizada y ejemplos de código para cualquier librería o framework.

## Workflow Principal

1.  **Encontrar ID de Librería**: Busca el ID compatible con Context7.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/context7 library "react" "hooks de uso general"
    ```

2.  **Consultar Documentación**: Usa el ID obtenido para hacer preguntas.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/context7 docs "/facebook/react" "cómo usar useEffect con operaciones async"
    ```

## Antes de Consultar
-   ¿Tengo el `libraryId` correcto? Usa `library` primero para resolver el nombre.
-   Los IDs siempre empiezan con `/` (ej: `/facebook/react`, `/vercel/next.js`).

## Optimización
-   Usa queries descriptivos, no keywords sueltos. `"cómo configurar autenticación con JWT"` > `"auth"`.
-   Agrega `--json` para output estructurado si necesitas parsear la respuesta.
