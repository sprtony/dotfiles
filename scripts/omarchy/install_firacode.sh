#!/bin/bash

# Salir inmediatamente si ocurre un error
set -e

FONT_NAME="FiraCode"
URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
INSTALL_DIR="$HOME/.local/share/fonts"
TEMP_DIR=$(mktemp -d)

echo "📦 Creando directorio temporal..."
cd "$TEMP_DIR"

echo "📥 Descargando FiraCode Nerd Font desde GitHub..."
wget -q --show-progress "$URL"

echo "📂 Creando directorio de fuentes en: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR/${FONT_NAME}"

echo "🤐 Descomprimiendo fuentes..."
unzip -q "${FONT_NAME}.zip" -d "$INSTALL_DIR/${FONT_NAME}"

echo "🔄 Actualizando la caché de fuentes del sistema..."
fc-cache -fv

echo "🧹 Limpiando archivos temporales..."
rm -rf "$TEMP_DIR"

echo "✨ ¡Instalación completada con éxito!"
echo "💡 Recuerda reiniciar tu terminal o editor de código (VS Code, Cursor, etc.) para aplicar los cambios."
