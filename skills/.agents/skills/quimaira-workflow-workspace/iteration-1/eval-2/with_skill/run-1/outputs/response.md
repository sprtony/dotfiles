# Cómo iniciar nuevo proyecto "Demo Cliente" en Quimaira

**Slug:** `demo-cliente` (minúsculas, guiones).

Orden ejecución:

## 1. BookStack — crear libro
- Cargar skill `bookstack-api-skill` (usar TOON sobre JSON).
- Crear **libro**: nombre `demo-cliente`.
- Dentro, crear los **7 capítulos** (Opción B):
  1. `Diseño`
  2. `Desarrollo`
  3. `Comunicaciones`
  4. `Video`
  5. `Administración`
  6. `Minutas`
  7. `Ideas / Propuestas`

## 2. BookStack — páginas base
- **Diseño:** `Assets`, `Brief`, `Especificaciones`.
- **Desarrollo:** `Repositorio`, `Stack`, `Estado Actual`.
- **Administración:** `Credenciales`, `Cuentas Finales`, `Cronograma`.

Credenciales (FTP, DB) van en `Administración > Credenciales`. Hash desplegado en `Desarrollo > Estado Actual`.

## 3. Kanboard — tag del proyecto
- Cargar skill `kanboard-skill` (JSON-RPC).
- Crear tag `demo-cliente` en proyecto `Proyectos` (si no existe).
- Default: tareas van a columna `Backlog`.

## 4. git-ftp — ofrecer inicialización
- Cargar `git-ftp-deploy` / `git-ftp-skill`.
- Ofrecer init si el proyecto tiene repo Git local listo. No asumir ruta; preguntar.

## 5. Confirmación
- Antes de crear en producción, confirmar con cliente/usuario.
- No expone contraseñas ni credenciales.

**Convenciones:** labels y textos en español; nombres de variables/funciones en inglés. Fuente de verdad = BookStack; tablero único = Kanboard.