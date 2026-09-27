# Flujo de trabajo — Agencia Quimaira

## Visión general

Orquesta coordinando **BookStack** (documentación), **Kanboard** (tareas) y **git-ftp** (despliegue). Skill orquestador delega en skills especializadas: `bookstack-api-skill`, `kanboard-skill`, `git-ftp-deploy` / `git-ftp-skill`.

## Fuentes de verdad y convenciones

- **BookStack** = fuente de verdad. Libro por proyecto, nombre = slug del cliente (minúsculas, guiones). Ej: `encuentro-de-curtiduria`.
- **Kanboard** = tablero único, proyecto `Proyectos`, columnas: `Backlog → Ready → In Progress → Review/QA → Ready to Deploy → Done`. Tag de Kanboard = mismo slug del proyecto.
- **Despliegue**: siempre `build → commit → git ftp push`.
- **Idioma**: español en caveman. Textos estáticos/labels/placeholders en español; variables/funciones en inglés.

## Estructura de libro (Opción B) — 7 capítulos

1. **Diseño** — Assets (Dropbox/Drive), Brief, Especificaciones (fuentes, colores, iconos).
2. **Desarrollo** — Repositorio, Stack, Estado Actual (último hash desplegado).
3. **Comunicaciones** — Estrategia, copys, plantillas.
4. **Video** — Guiones, edición, assets.
5. **Administración** — Credenciales (FTP, DB), Cuentas Finales, Cronograma.
6. **Minutas** — registro de reuniones.
7. **Ideas / Propuestas** — versionado de propuestas (V1, V2, …).

### Credenciales y estado

- Credenciales (FTP host/user/pass, DB) → página **Administración > Credenciales**.
- Último hash desplegado → **Desarrollo > Estado Actual**.

## Flujos por trigger

### Nuevo proyecto (`nuevo proyecto X`)
1. Crear libro en BookStack (slug + 7 capítulos).
2. Crear páginas base: Diseño (`Assets`, `Brief`, `Especificaciones`), Desarrollo (`Repositorio`, `Stack`, `Estado Actual`), Administración (`Credenciales`, `Cuentas Finales`, `Cronograma`).
3. Crear tag en Kanboard (`Proyectos`) si no existe.
4. Ofrecer inicializar git-ftp.

### Trabajar / abrir proyecto (`trabajar el proyecto X`)
1. Cargar contexto: libro en BookStack + tag en Kanboard.
2. No asumir ruta local: preguntar o usar directorio actual si es repo.
3. Confirmar que es repositorio Git válido.

### Generar tareas desde brief (`tareas del proyecto X`)
1. Leer brief en BookStack (Diseño o Ideas/Propuestas).
2. Crear micro-tareas en Backlog de `Proyectos`, tag del proyecto, enlace a página BookStack.

### Desplegar (`desplegar proyecto X`)
1. Cargar `git-ftp-deploy` o `git-ftp-skill`.
2. Leer credenciales desde `Administración > Credenciales`.
3. **Build** (detectar pnpm/npm/yarn).
4. Revisar `git status` y **commitar** con mensaje descriptivo.
5. `git ftp push`.
6. Kanboard → mover tarea a `Done`.
7. BookStack → actualizar `Desarrollo > Estado Actual` con hash.

### Hotfix (`hotfix proyecto X`)
1. Si edición directa en servidor: replicar en repo Git local.
2. `git ftp catchup` para sincronizar puntero del servidor.
3. Actualizar `Desarrollo > Estado Actual`.

### Assets de diseño nuevos (`assets nuevos proyecto X`)
1. Tarea en Backlog: `[DISEÑO] Nuevos assets detectados en Dropbox`.
2. Asignar tag + enlace al capítulo Diseño.

### Estado del proyecto (`estado del proyecto X`)
1. Consultar tareas de `Proyectos` filtrando por tag.
2. Resumir por columna: Backlog, Ready, In Progress, Review/QA, Ready to Deploy, Done.

## Reglas de comportamiento

- Pregunta "cómo se hace" → responder pasos, NO ejecutar.
- Petición de ejecutar → proceder.
- Antes de acciones destructivas (borrar, crear en producción, desplegar) → confirmar con usuario.
- NO exponer contraseñas ni credenciales en respuestas.
- NO asumir rutas locales; preguntar cuando falten.