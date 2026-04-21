---
name: chrome-devtools
description: Skill para interactuar con Chrome DevTools via MCP. Permite inspeccionar páginas, navegar, capturar snapshots y depurar.
allowed-tools: Bash(bash *)
---

# chrome-devtools

Este skill permite a los agentes de IA controlar una instancia de Chrome para tareas de navegación, depuración y extracción de datos.

## Flujo de Trabajo Principal

Utiliza el script envoltorio para todas las operaciones. **Importante:** Para ahorrar tokens en respuestas con muchas entradas (como listas de red o consola), utiliza siempre el flag `--toon`.

```bash
# Listar herramientas disponibles
${SERENA_SKILL_DIR}/scripts/chrome-devtools --list

# Ver ayuda de un comando específico
${SERENA_SKILL_DIR}/scripts/chrome-devtools <comando> --help

# Ejecutar con formato TOON (más eficiente en tokens)
${SERENA_SKILL_DIR}/scripts/chrome-devtools <comando> [opciones] --toon
```

## Comandos Críticos

- `list-pages`: Obtiene las pestañas abiertas. Úsalo con `--toon` si hay muchas.
- `new-page`: Abre una nueva URL.
- `navigate-page`: Navega en la pestaña actual.
- `take-snapshot`: Captura el árbol de accesibilidad de la página (excelente para entender el contenido sin ruido visual).
- `evaluate-script`: Ejecuta JavaScript en el contexto de la página.
- `list-console-messages`: Lista mensajes de consola (usa `--toon`).

## Mejores Prácticas y Consejos

- **Gestión de Contexto:** Antes de interactuar con una página, asegúrate de estar en el contexto correcto con `select-page` si hay múltiples pestañas.
- **Eficiencia de Tokens:** Para arrays grandes y uniformes, `--toon` reduce el uso de tokens entre un 40-60%.
- **Snapshots vs Screenshots:** Prefiere `take-snapshot` para análisis de texto y estructura, y `take-screenshot` solo cuando la representación visual sea estrictamente necesaria.
- **Espera Activa:** Usa `wait-for` para asegurar que el contenido se ha cargado antes de intentar interactuar con elementos.

## Ejemplos de Uso

```bash
# Listar páginas abiertas en formato TOON
${SERENA_SKILL_DIR}/scripts/chrome-devtools list-pages --toon --pretty

# Capturar un snapshot de accesibilidad detallado
${SERENA_SKILL_DIR}/scripts/chrome-devtools take-snapshot --verbose --pretty

# Evaluar un script para obtener el título
${SERENA_SKILL_DIR}/scripts/chrome-devtools evaluate-script --expression "document.title"
```
