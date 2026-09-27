# Pasos para desplegar "demo-cliente"

Orden de despliegue con git-ftp:

1. **Ir al proyecto** — abrir raíz de `demo-cliente`.
2. **Detectar gestor de paquetes** — usar `pnpm`/`npm`/`yarn` según lockfile existente.
3. **`git status --short`** — revisar cambios pendientes antes de tocar nada.
4. **Build** — compilar assets de producción (`pnpm run build` o equivalente). Si falla, parar aquí.
5. **Revisar cambios** — mostrar al usuario qué se va a commitear.
6. **Commit** — `git add -A` + `git commit -m "<mensaje>"` (pedir mensaje al usuario). Si no hay cambios, saltar este paso.
7. **Push** — `git ftp push` para subir archivos que hayan cambiado o sido borrados.
8. **Verificar** — reportar resultado (número de archivos subidos/eliminados).

Notas:
- Si falla el build, no commitear ni subir nada.
- Si no hay remoto git-ftp configurado, ejecutar `git ftp init` antes.
- Si `git ftp push` falla tras el commit, no reintentar solo: mostrar error y preguntar.
- Sin contraseñas ni credenciales expuestas en ningún mensaje ni log.