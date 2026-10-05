# Flujo de Trabajo de la Agencia Quimaira

El flujo de trabajo de Quimaira se basa en **tres herramientas centrales**: BookStack (fuente de verdad), Kanboard (gestión de tareas) y git-ftp + Git (control de versiones y despliegues). La IA (Gemini) actúa como agente que automatiza y sincroniza los procesos.

## 1. BookStack — Centralización de Información (Fuente de Verdad)

Cada proyecto DEBE tener su libro en BookStack con la siguiente estructura de capítulos:

- **Diseño:** Link a assets (Dropbox/Drive), brief, especificaciones (fuentes, paleta, iconos).
- **Desarrollo:** Credenciales de servidor y base de datos, URL del repositorio, stack (PHP/Node/MySQL).
- **Administración:** Cuentas finales de entrega para el cliente, cronograma e hitos.
- **Minutas:** Registro de cada reunión para evitar el "no se me avisó".
- **Ideas (Propuestas):** Versionado de propuestas (V1, V2, ...).

Beneficio clave: la IA puede leer estas páginas para automatizar despliegues y configuración sin intervención humana. Se evita saturar las tarjetas de Kanboard con datos.

## 2. Kanboard — Gestión de Tareas

Se abandona el modelo de "una tarjeta por proyecto". Cada acción técnica es una tarea independiente.

**Columnas obligatorias del tablero:**

1. **Backlog:** Ideas, requerimientos sueltos y tareas futuras.
2. **Ready (Listo):** Tareas priorizadas con información completa para empezar.
3. **In Progress:** Solo una tarea activa por desarrollador.
4. **Review / QA:** Tareas terminadas esperando validación o Code Review.
5. **Ready to Deploy:** Aprobado, listo para subir a producción.
6. **Done:** Tarea desplegada y verificada.

**Cada tarea debe contener:**

- Título claro (ej: "Configurar conexión PDO a DB" en lugar de "Base de datos").
- Link a la página de BookStack correspondiente (credenciales o requerimientos).
- Etiqueta de proyecto para filtrar por cliente/proyecto.

**Rol de la IA:** Lee el brief en BookStack y genera automáticamente las micro-tareas en el Backlog. Tras un despliegue exitoso, mueve la tarjeta de "Ready to Deploy" a "Done".

## 3. Ciclo de Vida del Desarrollo (Git + git-ftp)

1. **Inicio de tarea:** El desarrollador mueve la tarea en Kanboard a **In Progress** y crea una rama local en Git con el ID de la tarea (ej: `feature/K-123-login`).
2. **Desarrollo y commit:** Commits frecuentes con mensajes descriptivos. La IA puede revisar el código localmente antes del commit (errores de sintaxis o seguridad).
3. **Despliegue con git-ftp:** Prohibido subir manualmente por FileZilla/FTP. Obligatorio usar `git-ftp push`. La IA lee las credenciales desde BookStack, verifica la rama actual y ejecuta el despliegue a producción.
4. **Validación final:** La IA ejecuta un checklist automático (SEO, enlaces rotos, carga de imágenes). Si es positivo, mueve la tarea a **Review / QA** y notifica al responsable.

Beneficio: reducción de errores humanos en producción e historial de cada cambio vía Git.

## 4. Automatización y Sincronización Crítica

**Webhooks de Dropbox (Diseño -> Dev):** Webhook en la cuenta Dropbox de la agencia. Al detectar cambios, la IA crea una tarea/notificación en Kanboard: `[DISEÑO] Nuevos assets detectados en Dropbox`. Desarrollo recibe notificación instantánea.

**Proyectos recurrentes y Git:**
- Cada entrega anual o hito importante DEBE tener un `git tag` (ej: `v2025.1`).
- El capítulo Desarrollo de cada proyecto debe tener sección "Estado Actual" con el último hash desplegado exitosamente.

**Protocolo de Hotfixes (edición FTP directa):**
1. El cambio debe replicarse en el repositorio Git local de inmediato.
2. Ejecutar `git-ftp catchup` para sincronizar el puntero del servidor sin re-desplegar todo.
3. Antes de cada `push`, la IA verifica que `.git-ftp-last-committed-id` del servidor coincida con la rama actual, para evitar sobreescrituras accidentales.

## Resumen del flujo

```
Cliente/Brief -> BookStack (documentación y fuente de verdad)
      |
      v
Kanboard (Backlog -> Ready -> In Progress -> Review/QA -> Ready to Deploy -> Done)
      |
      v
Desarrollo local en Git -> git-ftp push -> Producción
      |
      v
Validación IA (checklist) + Automatización (Dropbox webhooks, hotfixes, tags)
```

Fuente: libro "Flujo de Trabajo" en BookStack (https://bookstack.avadig.com/books/flujo-de-trabajo).