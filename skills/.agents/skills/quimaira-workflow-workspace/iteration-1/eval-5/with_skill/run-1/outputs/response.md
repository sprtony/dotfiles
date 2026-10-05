# Organización del libro de BookStack en un proyecto Quimaira

Cada proyecto Quimaira = un libro en BookStack. Nombre = slug del proyecto (ej. `encuentro-de-curtiduria`). El libro DEBE tener 7 capítulos (Opción B):

1. **Diseño** — Assets (Dropbox/Drive), Brief, Especificaciones (fuentes, colores, iconos).
2. **Desarrollo** — Repositorio, Stack, Estado Actual (último hash desplegado).
3. **Comunicaciones** — Estrategia, copys, plantillas.
4. **Video** — Guiones, edición, assets.
5. **Administración** — Credenciales, Cuentas Finales, Cronograma.
6. **Minutas** — Registro de cada reunión.
7. **Ideas / Propuestas** — Versionado de propuestas (V1, V2, …).

## Páginas base por capítulo

- **Diseño**: `Assets`, `Brief`, `Especificaciones`.
- **Desarrollo**: `Repositorio`, `Stack`, `Estado Actual`.
- **Administración**: `Credenciales`, `Cuentas Finales`, `Cronograma`.

## Ubicación de datos sensibles

- Credenciales (FTP host/user/pass, DB) → única ubicación: página **Administración > Credenciales**. No exponer en respuestas.
- Último hash desplegado → **Desarrollo > Estado Actual**.

## Libro como fuente de verdad

BookStack = fuente de verdad del proyecto. Se consulta al trabajar, al generar tareas (Kanboard), al desplegar y al documentar hotfixes. Kanboard usa tag con mismo slug; el despliegue sigue orden build → commit → `git ftp push`.