---
name: chrome-devtools
description: Skill para interactuar con Chrome DevTools vía CLI nativo. Permite inspeccionar páginas, navegar, capturar snapshots y depurar.
allowed-tools: Bash(bash *)
---

# chrome-devtools

Controla una instancia de Chrome para navegación, depuración y extracción de datos usando el CLI nativo de Chrome DevTools.

## Inicio

Antes de usar comandos de página, asegúrate de que el daemon esté corriendo:

```bash
${CLAUDE_SKILL_DIR}/scripts/chrome-devtools start
${CLAUDE_SKILL_DIR}/scripts/chrome-devtools status
```

## Flujo de Trabajo Principal

```bash
# Listar pestañas abiertas
${CLAUDE_SKILL_DIR}/scripts/chrome-devtools list_pages

# Crear nueva pestaña y navegar
${CLAUDE_SKILL_DIR}/scripts/chrome-devtools new_page "https://example.com"

# Capturar snapshot de accesibilidad (mejor que screenshot para texto)
${CLAUDE_SKILL_DIR}/scripts/chrome-devtools take_snapshot

# Ejecutar JavaScript en la página activa
${CLAUDE_SKILL_DIR}/scripts/chrome-devtools evaluate_script "() => document.title"

# Listar mensajes de consola
${CLAUDE_SKILL_DIR}/scripts/chrome-devtools list_console_messages
```

## Comandos Críticos

-   `start` / `stop` / `status` — control del daemon.
-   `list_pages` — pestañas abiertas.
-   `new_page <url>` — abre URL.
-   `navigate_page <url>` — navega en la página seleccionada.
-   `take_snapshot` — árbol de accesibilidad de la página.
-   `evaluate_script <función>` — ejecuta JS y devuelve JSON.
-   `list_console_messages` — mensajes de consola.
-   `click <uid>` / `fill <uid> <valor>` / `hover <uid>` — interacción con elementos.

## Mejores Prácticas

-   Usa `take_snapshot` para análisis de texto; `take_screenshot` solo si necesitas representación visual.
-   Antes de interactuar con elementos, espera a que la página cargue (`wait_for`).
-   Si hay varias pestañas, selecciona la correcta con `select_page`.
-   Consulta ayuda de cada comando: `${CLAUDE_SKILL_DIR}/scripts/chrome-devtools <comando> --help`.
