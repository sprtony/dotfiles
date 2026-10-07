---
name: penpot
description: Conecta OpenCode con Penpot (self-hosted local) via mcp2cli. Usa para crear proyectos, archivos, shapes, exportar assets y sincronizar disenos generados por Impeccable.
---

# Penpot

Skill para interactuar con una instancia local de Penpot usando el CLI generado por `mcp2cli`.

## Requisitos

- Penpot debe estar corriendo: ejecuta `Applications/Penpot/bin/start-penpot`.
- `mcp2cli` debe estar instalado (`uv tool install mcp2cli`).
- El baked tool `penpot` debe existir (`mcp2cli bake create penpot --mcp http://localhost:8787/mcp`).

## CLI

El script `scripts/penpot` es un wrapper a `mcp2cli @penpot`.

```bash
# Listar equipos
penpot list-teams

# Listar proyectos de un equipo
penpot list-projects --team-id <ID>

# Crear proyecto
penpot create-project --team-id <ID> --name "Landing Page"

# Crear archivo
penpot create-file --project-id <ID> --name "Home"

# Crear rectangulo
penpot create-rectangle --file-id <ID> --page-id <ID> --name "Boton" --x 100 --y 100 --width 120 --height 40 --fill-color "#3B82F6"

# Crear texto
penpot create-text --file-id <ID> --page-id <ID> --name "Titulo" --text "Hola mundo" --x 100 --y 200 --font-size 24 --fill-color "#1F2937"

# Exportar frame a PNG
penpot export-frame-png --file-id <ID> --page-id <ID> --shape-id <ID> --output /tmp/export.png
```

## Descubrir comandos

```bash
penpot --list
penpot <comando> --help
```

## Flujo con Impeccable

1. Impeccable genera el diseno (tokens, componentes, layout).
2. Pide a OpenCode: *"Crea en Penpot el diseno que propuso Impeccable"*.
3. OpenCode usara esta skill para:
   - Crear proyecto/archivo si no existe.
   - Crear frames, shapes, textos y aplicar estilos.
   - Exportar assets o capturas para validacion.

## MCP oficial de Penpot (Opcion A)

Para usar el MCP oficial con un archivo abierto en el navegador, anade a `opencode.json` del proyecto:

```json
{
  "mcp": {
    "penpot-official": {
      "type": "remote",
      "url": "http://localhost:9001/mcp/stream?userToken=TOKEN"
    }
  }
}
```

El `userToken` se genera en Penpot: **Tu cuenta → Integraciones → MCP Server**.

## Notas

- Salida por defecto en JSON compacto.
- Penpot consume ~3-5 GB RAM idle; mantener bajo demanda.
- Web UI: http://localhost:9001
- MCP autonomo: http://localhost:8787/mcp
