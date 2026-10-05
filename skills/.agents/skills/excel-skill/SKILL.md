---
name: excel
description: Read, write, and manage Excel files.
allowed-tools: Bash(bash *)
---

# excel-skill

Gestión completa de archivos Excel desde la terminal usando [excel-cli](https://github.com/fuhan666/excel-cli).

## Requisito

`excel-cli` debe estar instalado (`cargo install excel-cli --locked`).

## Workflow Principal

### 1. Inspeccionar Workbook (listar hojas)

```bash
excel-cli inspect workbook "/ruta/archivo.xlsx"
```

### 2. Inspeccionar una hoja

```bash
excel-cli inspect sheet "/ruta/archivo.xlsx" --sheet "NombreHoja"
```

### 3. Muestrear datos (primeras N filas)

```bash
excel-cli inspect sample "/ruta/archivo.xlsx" --sheet "NombreHoja" --rows 10
```

### 4. Inspeccionar columnas (headers, tipos, metadata)

```bash
excel-cli inspect columns "/ruta/archivo.xlsx" --sheet "NombreHoja" --header-row auto
```

### 5. Leer una celda

```bash
excel-cli read cell "/ruta/archivo.xlsx" --sheet "NombreHoja" --cell B2
```

### 6. Leer un rango

```bash
excel-cli read range "/ruta/archivo.xlsx" --sheet "NombreHoja" --range A1:F20
```

### 7. Leer filas (con headers detectados)

```bash
excel-cli read rows "/ruta/archivo.xlsx" --sheet "NombreHoja"
```

### 8. Leer registros (objetos con keys del header)

```bash
excel-cli read records "/ruta/archivo.xlsx" --sheet "NombreHoja"
```

### 9. Leer con filtros, paginación y selección de columnas

```bash
excel-cli read records "/ruta/archivo.xlsx" --sheet "NombreHoja" \
  --select columna1,columna2 \
  --filter estado:eq:abierto \
  --filter total:gte:100 \
  --limit 50 \
  --offset 0
```

Operadores soportados: `eq`, `ne`, `gt`, `gte`, `lt`, `lte`, `contains`, `regex`, `isnull`, `notnull`.

### 10. Salida JSON Lines (para piping)

```bash
excel-cli read records "/ruta/archivo.xlsx" --sheet "NombreHoja" --output-shape jsonl
```

### 11. Calidad de datos (checks)

```bash
excel-cli check "/ruta/archivo.xlsx"
excel-cli check "/ruta/archivo.xlsx" --sheet "NombreHoja" --rules blank_headers,duplicate_values
excel-cli check "/ruta/archivo.xlsx" --severity-threshold warning
```

Reglas disponibles: `blank_headers`, `duplicate_headers`, `blank_rows`, `blank_columns`, `null_ratio`, `duplicate_values`, `type_drift`, `formula_presence`.

### 12. Abrir TUI interactivo (para edição)

```bash
excel-cli ui "/ruta/archivo.xlsx"
```

### 13. Buscar en archivos Excel (grep)

```bash
excel-cli grep "texto_buscar" /ruta/directorio/
excel-cli grep -i "texto" /ruta/ -f json
excel-cli grep -s "NombreHoja" "texto" /ruta/archivo.xlsx
```

## Formato de Salida

- Todos los comandos headless (`inspect`, `read`, `check`) devuelven JSON por defecto.
- Usa `--format text` para salida legible por humanos.
- El JSON sigue un envelope estable con `schema_version`, `command`, `file`, `target`, `data` y `warnings`.
- Las celdas vacías se representan como `null` en JSON.

## Escritura

`excel-cli` no tiene comandos de escritura headless. Para escribir datos:

1. **TUI interactivo**: `excel-cli ui archivo.xlsx` → presionar `Enter` en una celda para editar, `:w` para guardar.
2. **Python/openpyxl**: usar `python3` con `openpyxl` para escritura programática.

## Ejemplos Rápidos

```bash
# ¿Qué hojas tiene el archivo?
excel-cli inspect workbook datos.xlsx

# Ver primeras 5 filas de "Ventas"
excel-cli inspect sample datos.xlsx --sheet Ventas --rows 5

# Leer todos los registros con filtro
excel-cli read records datos.xlsx --sheet Ventas --filter region:eq:Norte --limit 20

# Verificar calidad
excel-cli check datos.xlsx --severity-threshold warning
```

