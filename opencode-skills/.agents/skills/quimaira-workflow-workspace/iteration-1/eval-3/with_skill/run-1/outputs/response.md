# Pasos para desplegar `demo-cliente`

Orden estricto: **build → commit → push** (skill `quimaira-workflow`).

## 1. Cargar skill de despliegue
Cargar `git-ftp-deploy` (incluye build y commit) o `git-ftp-skill`.

## 2. Leer credenciales
Leer desde BookStack → capítulo **Administración > Credenciales** (FTP host/user/pass).
No exponer contraseñas en respuestas.

## 3. Build
Ejecutar build detectando package manager: `pnpm` / `npm` / `yarn`.

## 4. Commit
- Revisar cambios con `git status`.
- Hacer commit con mensaje descriptivo.

## 5. Push
Ejecutar `git ftp push` para subir a producción.

## 6. Actualizar Kanboard
Mover la tarea del proyecto `demo-cliente` a la columna **Done**, filtrando por el tag del proyecto.

## 7. Actualizar BookStack
Actualizar **Desarrollo > Estado Actual** con el último hash desplegado.

> Nota: si hubo edición directa en servidor, primero replicar cambio en repo local y usar `git ftp catchup` (hotfix).