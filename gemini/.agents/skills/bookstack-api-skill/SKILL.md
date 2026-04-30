---
name: bookstack-api-skill
description: Interacciona con BookStack usando TOON (Token-Oriented Object Notation). Bajar tokens 60%. Gestiona Estantes, Libros, Páginas, etc. Soporta CRUD completo.
---

# BookStack API Ultra-Robust Skill (TOON Optimized)

Esta skill usa TOON para ahorrar tokens. Gemini debe preferir TOON.

## Formato TOON (Resumen)
- **Objetos:** `llave: valor` (usar 2 espacios para anidar).
- **Tablas:** `llave[cantidad]{campos}: valores` (separados por coma).
- **Ejemplo:**
  ```toon
  name: "Libro Nuevo"
  description: "Descripción"
  ```

## Comandos Principales

Estructura: `python3 scripts/bookstack_client.py <entidad> <accion> [opciones]`

### 1. Operaciones CRUD
- **Listar:** `python3 scripts/bookstack_client.py books list` (Salida en TOON por defecto).
- **Crear (con TOON):** `python3 scripts/bookstack_client.py pages create --toon 'name: "Título" book_id: 1 html: "Cuerpo"'`
- **Leer:** `python3 scripts/bookstack_client.py pages read --id 2`
- **Exportar:** `python3 scripts/bookstack_client.py pages export --id 2 --format pdf`

### 2. Opciones Extra
- `--output json`: Si Gemini necesita JSON (gasta más tokens).
- `--toon`: Para enviar datos en formato TOON.
- `--data`: Para enviar datos en formato JSON (tradicional).

## Entidades Soportadas
`shelves`, `books`, `chapters`, `pages`, `attachments`, `comments`, `roles`, `users`, `image-gallery`, `search`.

## Notas de Grog
- TOON es flaco, JSON es gordo.
- Gemini ser inteligente, Gemini usar TOON para ahorrar dinero de humano.

## Estructura Recomendada: Proyectos de Agencia

Para proyectos transversales (Ej: "Encuentro de curtiduría"), organizar así:

1. **Libros (Books):** Representan el proyecto completo.
2. **Capítulos (Chapters):** Dividir por áreas:
   - **Desarrollo:** Tech stack, DB, APIs.
   - **Diseño:** UI/UX, Assets, Figma.
   - **Comunicaciones:** Estrategia, Copys.
   - **Video:** Guiones, Edición.
   - **Administración:** Presupuestos, Facturación.
   - **Minutas:** Actas de reunión.
   - **Ideas (Propuestas):** Versionado de propuestas (V1, V2).

3. **Páginas (Pages):** Contenido técnico y acuerdos finales.

