---
name: excel
description: Read, write, and manage Excel files.
allowed-tools: Bash(bash *)
---

# excel-skill

Gestión completa de archivos Excel desde la terminal.

## Workflow Principal

1.  **Listar Hojas**: Mira qué hojas tiene el archivo.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/excel excel-describe-sheets --fileAbsolutePath "/ruta/archivo.xlsx" --toon
    ```

2.  **Leer Datos**: Extrae valores de una hoja específica.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/excel excel-read-sheet --fileAbsolutePath "/ruta/archivo.xlsx" --sheetName "Datos" --toon
    ```

3.  **Escribir Datos**: Inserta valores en un rango.
    ```bash
    ${CLAUDE_SKILL_DIR}/scripts/excel excel-write-to-sheet --fileAbsolutePath "/ruta/archivo.xlsx" --sheetName "Hoja1" --range "A1:B1" --values '[["Header1", "Header2"]]' --toon
    ```

## Formato de Salida
-   Usa siempre `--toon` para que los datos de las celdas no consuman tokens excesivos.

