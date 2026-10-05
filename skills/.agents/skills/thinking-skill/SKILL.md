---
name: thinking
description: Proceso de pensamiento secuencial para resolver problemas complejos paso a paso.
allowed-tools: Bash(bash *)
---

# thinking-skill

Proceso de pensamiento secuencial para resolver problemas complejos paso a paso.

## Workflow Principal

1.  **Iniciar Sesión**: Define meta y modo de razonamiento.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/thinking start --name "analisis" --goal "Diseñar arquitectura del módulo" --mode explore --totalSteps 5
    ```

2.  **Avanzar Paso**: Agrega contenido de cada paso.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/thinking step --sessionPath <ruta> --content "Paso 2: identificar dependencias críticas"
    ```

3.  **Repetir**: Continúa hasta completar los pasos configurados.

4.  **Revisar Sesión**: Muestra o exporta el razonamiento completo.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/thinking replay --sessionPath <ruta>
    ```

## Modos

-   `explore` — explorar opciones
-   `branch` — ramificar alternativas
-   `audit` — auditar/revisar conclusiones

## Optimización

-   Sé conciso en `--content` para ahorrar tokens.
-   Usa `--totalSteps 5` primero; amplía a `8` solo si el problema lo requiere.
