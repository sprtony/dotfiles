# ¿Dónde se guardan las credenciales de un proyecto en Quimaira?

Credenciales viven en **BookStack**. Cada proyecto tiene libro propio (slug del cliente) con 7 capítulos.

Ubicación exacta:

- **Página `Credenciales`** dentro del capítulo **Administración** (capítulo 5 del libro).
  - FTP (host / user / pass)
  - DB (credenciales base de datos)
  - Otras credenciales del proyecto

Ruta en BookStack:

```
Libro: {slug-del-cliente}
└── Capítulo 5: Administración
    ├── Credenciales      ← FTP, DB, cuentas
    ├── Cuentas Finales
    └── Cronograma
```

Datos asociados:

- **Último hash desplegado** → capítulo **Desarrollo**, página **`Estado Actual`**.

Regla: nunca exponer contraseñas en respuestas ni chats; consultarlas solo desde BookStack al momento de desplegar (build → commit → `git ftp push`).