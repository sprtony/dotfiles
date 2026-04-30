---
name: git-ftp-skill
description: Manejar despliegues profesionales con git-ftp. Sincronizar cambios local-remoto vía FTP/SFTP/FTPS. Usar para inicializar, empujar cambios, gestionar entornos (scopes), y manejar archivos ignorados o incluidos que no están en Git.
---

# git-ftp-skill

Interfaz experta para `git-ftp`. Permite despliegues quirúrgicos y seguros.

## Acciones Soportadas

- **init**: Sube todo el historial y crea archivo de log remoto.
- **push**: Sube cambios desde el último commit registrado en el servidor.
- **catchup**: Crea el log remoto sin subir nada (asume que los archivos ya están allí).
- **snapshot**: Crea una copia local de lo que se subiría.
- **show**: Muestra el commit que está actualmente en el servidor.
- **log**: Muestra el historial de despliegues (si el servidor lo soporta).
- **list**: Lista archivos en el servidor remoto.
- **download**: Descarga archivos del servidor (si están configurados).
- **add-scope/remove-scope**: Gestionar entornos (prod, dev, staging).

## Opciones Avanzadas

- `--syncroot <path>`: Sincronizar solo una subcarpeta (ej: `dist/` o `build/`).
- `--dry-run` (`-D`): Simular sin tocar el servidor. **Usar siempre si hay duda.**
- `--force` (`-f`): Forzar subida incluso si hay conflictos de log.
- `--insecure` (`-k`): Ignorar errores de certificado (útil para FTPS/SFTP privados).
- `--all` (`-a`): Ejecutar acción en todos los scopes configurados.
- `--cacert <file>`: Usar certificado CA específico.

## Manejo de Archivos Específicos

- **.git-ftp-ignore**: Archivos en Git que NO deben ir al servidor (ej: tests, docs internos).
- **.git-ftp-include**: Archivos NO en Git que DEBEN ir al servidor (ej: `.env` de producción, assets compilados, dependencias `node_modules` si es necesario).

## Mejores Prácticas

1. **Seguridad de Credenciales**:
   - Usar `git config` para `url`, `user` y `password` (aunque `password` mejor vía prompt o variable).
   - `git config git-ftp.url "sftp://servidor.com/app"`
2. **Entornos**:
   - Configurar scopes: `git ftp add-scope production sftp://...`
   - Desplegar: `git ftp push -s production`
3. **Flujo de Recuperación**:
   - Si el log remoto se corrompe: usar `catchup` si el código local coincide con el remoto.

## Reglas de Oro
- NUNCA exponer contraseñas en comandos directos si es posible.
- Verificar el `.git-ftp-ignore` antes de un `init` masivo.
- Usar `--syncroot` para proyectos modernos (React, Vue, Laravel) para subir solo lo necesario.
