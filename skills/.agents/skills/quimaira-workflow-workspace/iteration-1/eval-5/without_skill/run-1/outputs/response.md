# ¿Cómo se organiza un libro de BookStack para un proyecto de Quimaira?

## Estructura de 4 niveles

**Estante (Shelf)** → Agrupa libros de un mismo cliente o sector. Ej: `Estante: Quimaira — Cliente Alpha`.

**Libro (Book)** → Un libro por proyecto. Ej: `Libro: Sitio Web Cliente Alpha`.

**Capítulo (Chapter)** → Un capítulo por fase, módulo o área. Ej: `Capítulos: Planificación`, `Diseño`, `Desarrollo`, `QA`, `Deploy`, `Documentación`.

**Página (Page)** → Contenido concreto: requerimientos, decisiones, guías, manuales, actas.

## Reglas de oro

- **Un proyecto = un libro.** No mezclar proyectos en un libro. Usar estantes para agrupar.
- **Capítulos = fases del flujo Quimaira** (Planificación → Diseño → Desarrollo → QA → Deploy).
- **Una página = una idea.** Concreta, en español, con título claro.
- **Plantilla de página sugerida:**
  - `01-Objetivo`
  - `02-Alcance`
  - `03-Decisiones (ADR)`
  - `04-Repositorios y deploy (git-ftp)`
  - `05-Incidencias y QA`
  - `06-Actas de reunión`

## Tags (la clave)

Sistema de etiquetas uniforme en cada página:

| Tag | Valor |
|-----|-------|
| `cliente` | nombre del cliente |
| `proyecto` | slug del proyecto |
| `fase` | planificacion/diseño/desarrollo/qa/deploy |
| `tipo` | decision/reunion/guia/manual/acta |
| `kanboard` | ID de la tarea Kanboard enlazada |

## Integración con el flujo Quimaira

- **Kanboard** → Crea el libro al iniciar proyecto. Cada tarea grande → página. Usa tag `kanboard:ID` para enlazar.
- **git-ftp** → Página de deploy por proyecto con URL de servidor, scope y pasos. Tags `fase:deploy`.
- **Convención de nombres** → `30-Deploy-produccion`, numeración = orden natural del flujo.

## Ejemplo de árbol

```
Estante: Quimaira
└── Libro: Cliente Alpha — Sitio Web
    ├── Capítulo: Planificación
    │   ├── 01-Objetivo y alcance
    │   └── 02-Plan de fases
    ├── Capítulo: Desarrollo
    │   ├── 01-Arquitectura
    │   ├── 02-Repositorio y git-ftp
    │   └── 03-Decisiones técnicas
    ├── Capítulo: QA
    │   └── 01-Checklist de pruebas
    └── Capítulo: Deploy
        ├── 01-Puesta en producción
        └── 02-Playbook de despliegue
```

## Beneficios

- Cualquier miembro de Quimaira encuentra info en 3 clics.
- Kanboard = tareas (corto plazo), BookStack = conocimiento (largo plazo). No se pisan.
- Tag `kanboard` cruza ambas herramientas sin mantener links rotos.