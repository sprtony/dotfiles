---
name: quimaira-workflow
description: Orquesta el flujo de trabajo de la agencia Quimaira coordinando BookStack, Kanboard y git-ftp. Úsalo SIEMPRE que el usuario mencione la agencia Quimaira, el flujo de trabajo, iniciar un proyecto nuevo, trabajar en un proyecto, desplegar un proyecto, generar tareas de un proyecto, gestionar un hotfix, recibir assets de diseño o consultar el estado de un proyecto. Actívalo también cuando el usuario diga "nuevo proyecto X", "trabajar el proyecto X", "desplegar proyecto X", "estado del proyecto X" o "tareas del proyecto X", aunque no nombre explícitamente a Quimaira.
---

# Quimaira Workflow

Orquestador del flujo de trabajo de la agencia Quimaira. Este skill NO implementa las llamadas a APIs directamente: delega en las skills existentes (bookstack-api-skill, kanboard-skill, git-ftp-deploy / git-ftp-skill). Su misión es dar contexto y convenciones, y dirigir al modelo hacia la skill correcta para cada tarea.

## Principios

- **Fuente de verdad:** BookStack. Cada proyecto tiene su libro con documentación.
- **Tablero único:** Kanboard, proyecto `Proyectos`, con columnas `Backlog → Ready → In Progress → Review / QA → Ready to Deploy → Done`.
- **Despliegue:** SIEMPRE primero el build, luego commit y después `git ftp push`.
- **Idioma:** responder siempre en español y en modo caveman (tiro corto, sin rodeos).
- **Textos estáticos, labels y placeholders**: en español. Nombres de variables/funciones en inglés.

## Convenciones de nombres

- Nombre del proyecto = slug del cliente (minúsculas, guiones). Ej: `encuentro-de-curtiduria`.
- Libro en BookStack: nombre del proyecto (slug).
- Tag en Kanboard: mismo slug que el proyecto.
- Si el usuario da el nombre con espacios/tildes, convertirlo a slug. Si hay duda, preguntar.

## Estructura del libro en BookStack (Opción B)

Cada libro de proyecto DEBE tener estos capítulos:

1. **Diseño** — Assets (Dropbox/Drive), Brief, Especificaciones (fuentes, colores, iconos).
2. **Desarrollo** — Repositorio, Stack, Estado Actual (último hash desplegado).
3. **Comunicaciones** — Estrategia, copys, plantillas.
4. **Video** — Guiones, edición, assets.
5. **Administración** — Credenciales (FTP, DB), Cuentas Finales, Cronograma.
6. **Minutas** — registro de cada reunión.
7. **Ideas / Propuestas** — versionado de propuestas (V1, V2, …).

### Ubicación de credenciales

- Las credenciales (FTP host/user/pass, DB) van en la página **Administración > Credenciales**.
- El último hash desplegado va en **Desarrollo > Estado Actual**.

## Acciones y triggers

Activa la skill correcta según la petición.

### Nuevo proyecto
Trigger: `nuevo proyecto X`.
1. Cargar `bookstack-api-skill`.
2. Crear libro en BookStack con nombre slug y los 7 capítulos de la Opción B.
3. Crear páginas base: en Diseño `Assets`, `Brief`, `Especificaciones`; en Desarrollo `Repositorio`, `Stack`, `Estado Actual`; en Administración `Credenciales`, `Cuentas Finales`, `Cronograma`.
4. Cargar `kanboard-skill` y crear el tag del proyecto en el proyecto `Proyectos` (si no existe).
5. Ofrecer inicializar git-ftp si corresponde.

### Trabajar / abrir proyecto
Trigger: `trabajar el proyecto X`.
1. Cargar contexto: libro en BookStack, tag en Kanboard.
2. Los proyectos están en carpetas locales diversas: NO asumir ruta. Preguntar la ruta o usar el directorio de trabajo actual si es un repo.
3. Confirmar que es un repositorio Git válido.

### Generar tareas desde el brief
Trigger: `tareas del proyecto X`.
1. Leer el brief en BookStack (capítulo Diseño o Ideas/Propuestas).
2. Cargar `kanboard-skill` y crear micro-tareas en el Backlog del proyecto `Proyectos`.
3. Cada tarea: título claro, tag del proyecto, enlace a la página de BookStack pertinente.

### Desplegar proyecto
Trigger: `desplegar proyecto X`.
Siempre en este orden: **build → commit → push**.
1. Cargar `git-ftp-deploy` (incluye build y commit) o `git-ftp-skill`.
2. Leer credenciales desde `Administración > Credenciales` en BookStack.
3. Ejecutar el build (detectar package manager: pnpm/npm/yarn).
4. Revisar cambios (`git status`), hacer commit con mensaje descriptivo.
5. Ejecutar `git ftp push`.
6. Actualizar Kanboard: mover la tarea a `Done`.
7. Actualizar en BookStack `Desarrollo > Estado Actual` con el hash desplegado.

### Hotfix
Trigger: `hotfix proyecto X`.
1. Si hubo edición directa en servidor: replicar el cambio en el repo Git local de inmediato.
2. Ejecutar `git ftp catchup` para sincronizar el puntero del servidor.
3. Actualizar `Desarrollo > Estado Actual`.

### Assets de diseño nuevos
Trigger: `assets nuevos proyecto X`.
1. Crear en Kanboard una tarea en Backlog: `[DISEÑO] Nuevos assets detectados en Dropbox`.
2. Asignar tag del proyecto y enlace al capítulo de Diseño en BookStack.

### Estado del proyecto
Trigger: `estado del proyecto X`.
1. Cargar `kanboard-skill` y consultar las tareas del proyecto `Proyectos` filtrando por el tag del proyecto.
2. Resumir por columna (Backlog, Ready, In Progress, Review/QA, Ready to Deploy, Done).

## Comportamiento

- Si el usuario pregunta "cómo se hace" o "cuáles son los pasos": RESPONDER con los pasos, NO ejecutar.
- Si el usuario pide ejecutar: proceder.
- Antes de acciones destructivas (borrar, crear en producción, despliegue), confirmar con el usuario.
- No exponer contraseñas ni credenciales en las respuestas.
- No asumir rutas locales; preguntar cuando falten.
