# Cómo iniciar nuevo proyecto "Demo Cliente" en Quimaira

**Slug:** `demo-cliente` (minúsculas, guiones).

Orden de ejecución:

## 1. BookStack — libro del proyecto
- Crear **libro** con nombre `demo-cliente` (slug del proyecto).
- Dentro, crear los **7 capítulos**:
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

Credenciales (FTP, DB, cuentas) → única ubicación: página `Administración > Credenciales`. Último hash desplegado → `Desarrollo > Estado Actual`.

## 3. Kanboard — tag del proyecto
- Crear tag `demo-cliente` en el proyecto `Proyectos` (si no existe).
- Tareas del cliente se etiquetan con ese tag; default en columna `Backlog`.

## 4. git-ftp — despliegue
- Editorial local con repo Git listo → configurar e inicializar `git-ftp` para `demo-cliente` (host según credenciales de BookStack).
- Flujo de despliegue: `build` → `commit` → `git ftp push`. No asumir ruta del repo; preguntar.

## 5. Confirmación
- Antes de crear en producción, confirmar con cliente/usuario.
- Nunca exponer contraseñas ni credenciales en respuestas.

**Convenciones:** textos y labels en español; nombres de variables/funciones en inglés. BookStack = fuente de verdad; Kanboard = tablero único de tareas; git-ftp = despliegue.