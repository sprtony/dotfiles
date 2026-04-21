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
    ${CLAUDE_SKILL_DIR}/scripts/context7 resolve-library-id --libraryName "React" --query "hooks" --toon
    ```

2.  **Consultar Documentación**: Usa el ID obtenido para hacer preguntas.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/context7 query-docs --libraryId "/vercel/next.js" --query "server components" --toon
    ```

## Antes de Consultar
-   ¿Tengo el `libraryId` correcto? Usa `resolve-library-id` primero.
-   Asegúrate de que la variable de entorno `CONTEXT7_API_KEY` esté configurada.

## Optimización
-   Usa siempre `--toon` para minimizar el consumo de tokens en las respuestas de documentación extensa.

