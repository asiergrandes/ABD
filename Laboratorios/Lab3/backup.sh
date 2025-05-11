#!/bin/bash

# Definir variables
BACKUP_SOURCE="/SGSSI"  # Cambia esto a la ruta de la carpeta Seguridad
BACKUP_DESTINATION="/var/tmp/Backups"  # Cambia esto a la ruta donde deseas almacenar las copias
DATE=$(date +"%Y-%m-%d")  # Obtener la fecha actual en formato YYYY-MM-DD
BACKUP_DIR="$BACKUP_DESTINATION/$DATE"  # Crear la ruta de destino para la copia

# Crear la carpeta de destino si no existe
mkdir -p "$BACKUP_DIR"

# Realizar la copia de seguridad incremental
rsync -av --link-dest="$BACKUP_DESTINATION/latest" "$BACKUP_SOURCE/" "$BACKUP_DIR/"

# Crear un enlace simbólico a la última copia
rm -f "$BACKUP_DESTINATION/latest"  # Eliminar enlace simbólico anterior
ln -s "$BACKUP_DIR" "$BACKUP_DESTINATION/latest"  # Crear nuevo enlace simbólico
